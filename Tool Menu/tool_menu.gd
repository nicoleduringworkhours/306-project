extends Control

signal tool_selected(tool_name)

var selected_button: TextureButton = null
var tools = ["shovel", "watering_can", "hoe"]
var current_tool_index: int = 0
var active_tweens: Dictionary = {}  # tracks the tweens per button

@onready var tool_buttons := {
    "shovel": $"Toolbox container/ToolShovel",
    "watering_can": $"Toolbox container/ToolWateringCan",
    "hoe": $"Toolbox container/ToolHoe",
}

func _ready():
    highlight_tool(tools[current_tool_index])


func _on_tool_pressed(tool_name: String, button: TextureButton):
    highlight_tool(tool_name)
    Sound.play_sfx(Sound.EFFECT.UI_CLICK)
    
    var tool_icon = button.texture_normal
    if tool_icon:
        Input.set_custom_mouse_cursor(tool_icon)
    else:
        Input.set_custom_mouse_cursor(null)

    emit_signal("tool_selected", tool_name)


func _on_tool_shovel_pressed() -> void:
    _on_tool_pressed("shovel", tool_buttons["shovel"])

func _on_tool_watering_can_pressed() -> void:
    _on_tool_pressed("watering_can", tool_buttons["watering_can"])

func _on_tool_hoe_pressed() -> void:
    _on_tool_pressed("hoe", tool_buttons["hoe"])


func highlight_tool(tool_name: String):
    var button = tool_buttons.get(tool_name)
    if not button:
        return

    if selected_button and selected_button != button:
        animate_tween(selected_button, Vector2.ONE)
        selected_button.modulate = Color(1, 1, 1)

    selected_button = button
    selected_button.modulate = Color(1, 1, 0)
    animate_tween(selected_button, Vector2(1.2, 1.2))
    current_tool_index = tools.find(tool_name)


# helper to create / replace a tween for each button
func animate_tween(button: TextureButton, target_scale: Vector2):
    if active_tweens.has(button) and active_tweens[button].is_valid():
        active_tweens[button].kill()

    var t = create_tween()
    t.tween_property(button, "scale", target_scale, 0.15)\
        .set_trans(Tween.TRANS_SINE)\
        .set_ease(Tween.EASE_OUT)
    active_tweens[button] = t


# handles mouse scroll + hotkeys
func _unhandled_input(event):
    if event is InputEventMouseButton and event.is_pressed():
        if event.button_index == MOUSE_BUTTON_WHEEL_UP:
            switch_tool(-1)
        elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
            switch_tool(1)

    elif event is InputEventKey and event.is_pressed():
        match event.keycode:
            KEY_1:
                set_tool_name("shovel")
            KEY_2:
                set_tool_name("watering_can")
            KEY_3:
                set_tool_name("hoe")


func switch_tool(direction: int):
    current_tool_index = (current_tool_index + direction) % tools.size()
    var next_tool = tools[current_tool_index]
    var button = tool_buttons[next_tool]
    _on_tool_pressed(next_tool, button)


func set_tool_name(tool_name: String):
    if tool_name in tools:
        var button = tool_buttons[tool_name]
        _on_tool_pressed(tool_name, button)

func get_selected_tool() -> String:
    return tools[current_tool_index]
