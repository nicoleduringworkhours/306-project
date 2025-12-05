extends RefCounted
class_name ToolModel

const FERTILIZER_COST = 30  #Cost to access fertilizer
const FERTILIZER_DURATION = 120.0 # in seconds (2 mins)

enum tools {SHOVEL=0, WATERING_CAN=1, HOE=2, FERTILIZER= 3}
const TOOLSIZE = 4
var current_tool

var fert_unlock: bool = false
var money_check: Callable

var fert_timer: Timer

signal model_changed()
signal money_change(val: int)

func _init() -> void:
    fert_timer = Timer.new()
    fert_timer.one_shot = true
    fert_timer.wait_time = FERTILIZER_DURATION

    fert_timer.timeout.connect(func ():
        fert_unlock = false
        model_changed.emit()
    )

func get_timer() -> Timer:
    return fert_timer

func set_money_check(c: Callable) -> void:
    money_check = c

func get_tool() -> tools:
    return current_tool

func set_tool(t: tools) -> void:
    current_tool = t
    model_changed.emit()

## Cycles the selected tool forward or backward.
## @param direction: +1 to go forward, -1 to go backward in the tool list.
func switch_tool(direction: int):
    var t = ((current_tool as int) + direction) % TOOLSIZE
    if t < 0:
        t = TOOLSIZE - 1
    set_tool(t)


## Checks whether fertilizer is unlocked; if not, attempts to unlock it.
## - If `fert_unlock` is false and the player has enough money:
##     - Deducts `FERTILIZER_COST` from player via `money_change` signal, Starts the fertilizer timer, Shows the countdown label.
## @return: `true` if fertilizer is unlocked/active, `false` otherwise.
func unlock_fertilizer() -> void:
    if not fert_unlock and money_check.call() >= FERTILIZER_COST:
        fert_unlock = true
        fert_timer.start()
        money_change.emit(-FERTILIZER_COST)
        model_changed.emit()

func fertilizer_unlocked() -> bool:
    return fert_unlock
