extends TileMapLayer
class_name CropMap

# Controller signals
signal seed_planted(crop_type: Crop.crop)
# Fertilizer unlock state
var fertilizer_unlocked: bool = false
var fertilizer_unlock_end_time: float = 0.0

const FERTILIZER_COST := 30
const FERTILIZER_DURATION := 120.0  # 3 minutes in seconds
# Model
var rows: int
var cols: int
const STAGES: int = 5
const STAGE_TIME: int = 2

var money_check: Callable

enum actions {ADVANCE=-1, FAIL=-2, TRY_GROW=-3, HARVEST=-4} ## actions on tiles

## non-timeout based states, of the form (state, action): state
var state_machine: Dictionary

## timeout based state transitions, of the form state: (state, time in seconds)
var timer_states: Dictionary = {}

## tile manager model
var ag: AutomataGrid
var pm: PlotMap

func data(r: int, c: int, p: PlotMap) -> CropMap:
    rows = r
    cols = c
    pm = p
    return self

func set_money_ref(money_func: Callable) -> void:
    money_check = money_func

## set-up. Creates a TM_Manager model, does initial renders of all tiles
## actions on tiles
func _ready() -> void:
    for c in Crop.crop.values():
        if c != Crop.crop.NONE:
            for i in range(STAGES - 1):
                var v = (STAGES-i)*10+c
                # initiate growth
                state_machine[Vector2i(v, actions.TRY_GROW)] = -100*v
                timer_states[-100*v] = Vector2i(-100*v+1, STAGE_TIME)
                # growth checks
                state_machine[Vector2i(-100*v+1, actions.ADVANCE)] = v-10
                state_machine[Vector2i(-100*v+1, actions.FAIL)] = v

            # harvest crop
            state_machine[Vector2i(10+c, actions.HARVEST)] = Crop.crop.NONE

            # plant crop
            state_machine[Vector2i(Crop.crop.NONE, c)] = STAGES*10 + c

    ag = AutomataGrid.new(cols, rows, Crop.crop.NONE, state_machine, timer_states)
    ag.cell_update.connect(_cell_update)

    add_child(ag.get_timer())

# View

## signal handler to deal with visual updates.
func _cell_update(x: int, y: int, state: int) -> void:
    if state == Crop.crop.NONE:
        set_cell(Vector2i(x,y), 0, Vector2i(-1, 0))
    elif state > 0:
        set_cell(Vector2i(x,y), 0, Vector2i(state / 10, state % 10))
        if pm.is_watered(x,y):
            ag.transition(x,y, actions.TRY_GROW)
    elif pm.is_watered(x,y):
        ag.transition(x,y, actions.ADVANCE)
    else:
        ag.transition(x,y, actions.FAIL)

# Controller
signal money_change(val: int)

func hoe_press(loc: Vector2):
    var a = local_to_map(loc)
    if a.x >= 0 and a.x <= cols and a.y >= 0 and a.y <= rows:
        _try_harvest(a.x,a.y)

func shovel_press(loc: Vector2, _seed: Crop.crop) -> void:
    var a = local_to_map(loc)
    if a.x >= 0 and a.x <= cols and a.y >= 0 and a.y <= rows:
        if pm.can_plant(a.x,a.y) and ag.get_tile(a.x,a.y) == 0 \
                and money_check.call() >= Crop.crop_cost[_seed]:
            money_change.emit(-Crop.crop_cost[_seed])
            ag.transition(a.x,a.y, _seed)
        _try_harvest(a.x,a.y)
    #Sound.play_sfx(Sound.EFFECT.INTERACT)

func _try_harvest(x: int, y: int):
    var val = ag.get_tile(x, y)
    if val != 0 and Crop.crop_val.has(val-10):
        val = Crop.crop_val[val-10]

        ag.transition(x,y, actions.HARVEST)
        if ag.get_tile(x, y) == Crop.crop.NONE: # harvest success
            money_change.emit(val)

func got_watered(x: int, y: int):
    ag.transition(x, y, actions.TRY_GROW)
    

func fertilizer_press(loc: Vector2, _seed: Crop.crop) -> void:
    var a := local_to_map(loc)

    # bounds check
    if a.x < 0 or a.x >= cols or a.y < 0 or a.y >= rows:
        return

    # no seed selected
    if _seed == Crop.crop.NONE:
        return

    # --- unlock / timer logic ---
    var now := Time.get_unix_time_from_system()

    # if previously unlocked but time expired, relock
    if fertilizer_unlocked and now >= fertilizer_unlock_end_time:
        fertilizer_unlocked = false

    # if not unlocked, tries to unlock for 30
    if not fertilizer_unlocked:
        var current_money: int = money_check.call()
        if current_money < FERTILIZER_COST:
            print("Not enough money to unlock fertilizer (need %d)." % FERTILIZER_COST)
            return

        # pay 30 once and start the window
        money_change.emit(-FERTILIZER_COST)
        fertilizer_unlocked = true
        fertilizer_unlock_end_time = now + FERTILIZER_DURATION
        print("Fertilizer unlocked for %d seconds." % int(FERTILIZER_DURATION))

    var current_state: int = ag.get_tile(a.x, a.y)

    # only on tiles that are allowed to be planted on (i.e., tilled by hoe) and currently empty
    if not pm.can_plant(a.x, a.y) or current_state != Crop.crop.NONE:
        return

    # charges the seed being planted 
    seed_planted.emit(_seed)

    # set to fully grown state: 10 + crop_type
    var final_state: int = 10 + int(_seed)
    ag.set_tile(a.x, a.y, final_state)
    _cell_update(a.x, a.y, final_state)
    Sound.play_sfx(Sound.EFFECT.INTERACT)
