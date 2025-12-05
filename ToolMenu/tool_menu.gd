extends Control
## Tool selection UI controller for the farming game.
## 
## Responsibilities:
## - Manage the active tool (shovel, watering can, hoe, fertilizer).
## - Update cursor icon and visual highlight for the selected tool.
## - Handle tool selection via buttons, hotkeys, and mouse scroll.
## - Manage fertilizer unlocking: cost, duration timer, and UI label.

signal tool_selected(t: tools)  

const FERTILIZER_COST = 30  #Cost to access fertilizer
const FERTILIZER_DURATION = 120.0 # in seconds (3 mins)

enum tools {SHOVEL=0, WATERING_CAN=1, HOE=2, FERTILIZER= 3}
const TOOLSIZE = 4
var current_tool
var prev_button: TextureButton
@onready var fert_timer: Timer = Timer.new()
@onready var timer_label: Label = $ToolboxContainer/FertilizerLabel  #Fertilizer timer label
var fert_unlock: bool = false
var money_check: Callable
var active_tweens: Dictionary = {}  # tracks the tweens per button

## Mapping from tool enum values to their corresponding UI buttons.
@onready var tool_buttons := {
    tools.SHOVEL: $"ToolboxContainer/ToolShovel",
    tools.WATERING_CAN: $"ToolboxContainer/ToolWateringCan",
    tools.HOE: $"ToolboxContainer/ToolHoe",
    tools.FERTILIZER: $"ToolboxContainer/ToolFertilizer"
}

## Initializes the toolbox UI and fertilizer timer.
## - Selects the default tool.
## - Configures fertilizer timer behaviour.
func _ready():
    select_tool(tools.SHOVEL)
    fert_timer.one_shot = true
    fert_timer.timeout.connect(func ():
        fert_unlock = false
        timer_label.visible = false
    )
    fert_timer.wait_time = FERTILIZER_DURATION
    add_child(fert_timer)

## Per-frame update of the fertilizer timer label text.
## Label will typically only be visible while fertilizer is active.
func _process(_delta: float):
    timer_label.text = "Fertilizer Time: " + str(fert_timer.get_time_left() as int)

## Injects a money-check function from HUD / game controller.
func set_money_ref(money_func: Callable) -> void:
    money_check = money_func

## Sets the current tool selection and updates related UI/behaviour.
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

## Visually highlights the selected tool button and un-highlights the previous one.
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

## Cycles the selected tool forward or backward.
## @param direction: +1 to go forward, -1 to go backward in the tool list.
func switch_tool(direction: int):
    var t = ((current_tool as int) + direction) % TOOLSIZE
    if t < 0:
        t = TOOLSIZE - 1
    select_tool(t)

func get_selected_tool() -> tools:
    return current_tool

signal money_change(val: int)

## Checks whether fertilizer is unlocked; if not, attempts to unlock it.
## - If `fert_unlock` is false and the player has enough money:
    ##     - Deducts `FERTILIZER_COST` from player via `money_change` signal, Starts the fertilizer timer, Shows the countdown label.
## @return: `true` if fertilizer is unlocked/active, `false` otherwise.
func fertilizer_unlocked() -> bool:
    if not fert_unlock and money_check.call() >= FERTILIZER_COST:
        fert_unlock = true
        timer_label.visible = true
        fert_timer.start()
        money_change.emit(-FERTILIZER_COST)
    return fert_unlock
