extends Control

signal tool_selected(t: tools)

enum tools {SHOVEL=0, WATERING_CAN=1, HOE=2, FERTILIZER= 3}
const TOOLSIZE = 4
var current_tool
var prev_button: TextureButton

var active_tweens: Dictionary = {}  # tracks the tweens per button

@onready var tool_buttons := {
    tools.SHOVEL: $"ToolboxContainer/ToolShovel",
    tools.WATERING_CAN: $"ToolboxContainer/ToolWateringCan",
    tools.HOE: $"ToolboxContainer/ToolHoe",
    tools.FERTILIZER: $"ToolboxContainer/ToolFertilizer"
}

func _ready():
    select_tool(tools.SHOVEL)

func select_tool(t: tools):
    current_tool = t
    highlight_tool(t)
    Sound.play_sfx(Sound.EFFECT.UI_CLICK)

    var tool_icon = tool_buttons[t].texture_normal
    if tool_icon:
        Input.set_custom_mouse_cursor(tool_icon)

    tool_selected.emit(t)

func _on_tool_shovel_pressed() -> void:
    select_tool(tools.SHOVEL)

func _on_tool_watering_can_pressed() -> void:
    select_tool(tools.WATERING_CAN)

func _on_tool_hoe_pressed() -> void:
    select_tool(tools.HOE)
    
func _on_tool_fertilizer_pressed() -> void:
    select_tool(tools.FERTILIZER)

func highlight_tool(t: tools):
    var button = tool_buttons[t]

    if prev_button and prev_button != button:
        animate_tween(prev_button, Vector2.ONE)
        prev_button.modulate = Color(1, 1, 1, 1)

    prev_button = button
    button.modulate = Color(1, 1, 0, 1)
    animate_tween(button, Vector2(1.2, 1.2))

# helper to create / replace a tween for each button
func animate_tween(button: TextureButton, target_scale: Vector2):
    if active_tweens.has(button) and active_tweens[button].is_valid():
        active_tweens[button].kill()

    var t = create_tween()
    t.tween_property(button, "scale", target_scale, 0.15)\
        .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
    active_tweens[button] = t

# handles mouse scroll + hotkeys
func _unhandled_input(event):
    if event.is_action_pressed("hotkey_1"):
        select_tool(tools.SHOVEL)
    elif event.is_action_pressed("hotkey_2"):
        select_tool(tools.WATERING_CAN)
    elif event.is_action_pressed("hotkey_3"):
        select_tool(tools.HOE)
    elif event.is_action_pressed("hotkey_4"):
        select_tool(tools.FERTILIZER)
    elif event.is_action_pressed("scroll_up"):
        switch_tool(-1)
    elif event.is_action_pressed("scroll_down"):
        switch_tool(1)

func switch_tool(direction: int):
    var t = ((current_tool as int) + direction) % TOOLSIZE
    if t < 0:
        t = TOOLSIZE - 1
    select_tool(t)

func get_selected_tool() -> tools:
    return current_tool
