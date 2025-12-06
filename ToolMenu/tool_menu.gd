extends Control
class_name ToolMenu
## Tool selection UI controller
##
## Responsibilities:
## - Update cursor icon and visual highlight for the selected tool.
## - Handle tool selection via buttons, hotkeys, and mouse scroll.

signal tool_selected(t: ToolModel.tools)
signal money_change(val: int)

@onready var timer_label: Label = $ToolboxContainer/FertilizerLabel ## Fertilizer timer label

## the model containing state
var model: ToolModel

## tracks the previously highlighted button so it can be un-highlighted
var prev_button: TextureButton
var active_tweens: Dictionary = {} # tracks the tweens per button

## Mapping from tool enum values to their corresponding UI buttons.
@onready var tool_buttons = {
    ToolModel.tools.SHOVEL: $ToolboxContainer/ToolShovel,
    ToolModel.tools.WATERING_CAN: $ToolboxContainer/ToolWateringCan,
    ToolModel.tools.HOE: $ToolboxContainer/ToolHoe,
    ToolModel.tools.FERTILIZER: $ToolboxContainer/ToolFertilizer,
}

## Initializes the toolbox UI, connects engine components to model
## - Selects the default tool.
func _ready():
    # init model
    model = ToolModel.new()
    model.model_changed.connect(on_model_changed)
    model.set_tool(ToolModel.tools.SHOVEL)
    model.money_change.connect(money_change.emit)
    add_child(model.get_timer())

    # bind buttons to model changes for shovel, hoe, watering can
    for t in ToolModel.tools:
        tool_buttons[ToolModel.tools[t]].pressed.connect( \
            model.set_tool.bind(ToolModel.tools[t]))

## Per-frame update of the fertilizer timer label text.
## Label will only be visible while fertilizer is active.
func _process(_delta: float):
    timer_label.text = "Fertilizer Time: " + str(model.get_timer().get_time_left() as int)

## Injects a money-check function from HUD / game controller.
func set_money_ref(money_func: Callable) -> void:
    model.set_money_check(money_func)

## Sets the current tool selection and updates related UI/behaviour.
func on_model_changed():
    var t = model.get_tool()
    tool_selected.emit(t)
    highlight_tool(t)

    var tool_icon = tool_buttons[t].texture_normal
    if tool_icon:
        Input.set_custom_mouse_cursor(tool_icon)

    Sound.play_sfx(Sound.EFFECT.UI_CLICK)

    timer_label.visible = model.fertilizer_unlocked()

## Visually highlights the selected tool button and un-highlights the previous one.
func highlight_tool(t: ToolModel.tools):
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
        model.set_tool(ToolModel.tools.SHOVEL)
    elif event.is_action_pressed("hotkey_2"):
        model.set_tool(ToolModel.tools.WATERING_CAN)
    elif event.is_action_pressed("hotkey_3"):
        model.set_tool(ToolModel.tools.HOE)
    elif event.is_action_pressed("hotkey_4"):
        model.set_tool(ToolModel.tools.FERTILIZER)
    elif event.is_action_pressed("scroll_up"):
        model.switch_tool(-1)
    elif event.is_action_pressed("scroll_down"):
        model.switch_tool(1)

func get_selected_tool() -> ToolModel.tools:
    return model.get_tool()

## unlock fertilizer if possible, and return true if fertilizer is
## unlocked
func fertilizer_unlocked() -> bool:
    model.unlock_fertilizer()
    return model.fertilizer_unlocked()
