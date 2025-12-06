extends RefCounted
class_name ToolModel

const FERTILIZER_COST = 30  #Cost to access fertilizer
const FERTILIZER_DURATION = 120.0 # in seconds (2 mins)

## the selectable tools
enum tools {SHOVEL=0, WATERING_CAN=1, HOE=2, FERTILIZER= 3}
const TOOLSIZE = 4
var current_tool

## the state of the fertilizer, unlocked and time remaining
var fert_unlock: bool = false
var money_check: Callable ## reference to the current money for unlocking fertilizer

var fert_timer: Timer

signal model_changed() ## emitted when the model is changed
signal money_change(val: int) ## add the amount [param val] to the players money

## initialize the model
func _init() -> void:
    # set up the timer
    fert_timer = Timer.new()
    fert_timer.one_shot = true
    fert_timer.wait_time = FERTILIZER_DURATION

    fert_timer.timeout.connect(func ():
        fert_unlock = false
        model_changed.emit()
    )

## get the timer (to add to the tree)
func get_timer() -> Timer:
    return fert_timer

## set the money check function to [param c]
func set_money_check(c: Callable) -> void:
    money_check = c

## get the current tool
func get_tool() -> tools:
    return current_tool

## set the current tool to [param t]
func set_tool(t: tools) -> void:
    current_tool = t
    model_changed.emit()

## Cycles the selected tool forward or backward.
## [param direction] +1 to go forward, -1 to go backward in the tool list.
func switch_tool(direction: int):
    var t = ((current_tool as int) + direction) % TOOLSIZE
    if t < 0:
        t = TOOLSIZE - 1
    set_tool(t)

## attempts to unlock fertilizer, does nothing if unlocked
## or the player cannot afford the fertilizer
func unlock_fertilizer() -> void:
    if not fert_unlock and money_check.call() >= FERTILIZER_COST:
        fert_unlock = true
        fert_timer.start()
        money_change.emit(-FERTILIZER_COST)
        model_changed.emit()

## returns if the fertilizer is unlocked
func fertilizer_unlocked() -> bool:
    return fert_unlock
