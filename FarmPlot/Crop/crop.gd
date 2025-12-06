extends TileMapLayer
class_name CropMap

## Manages crop growth, planting and harvesting on tilemap grid
## CropMap uses AutomataGrid to manage crop growth and transitions. The crop
## system uses the following encoding for each crop state:
## 0: Empty
##  > 0 (XY): x = crop stage, Y = crop type
## Negative values : timer-based growth states

# Controller signals
signal money_change(val: int) ## emitted to change player money by [param val]

# Model
var rows: int ## number of rows in crop grid

var cols: int ## number of columns in crop grid

const STAGES: int = 5 ## total number of growth stages for crops

const STAGE_TIME: int = 2 ## time in seconds for each growth stage

var money_check: Callable ## function to check if player has enough money for planting

enum actions {ADVANCE=-1, FAIL=-2, TRY_GROW=-3, HARVEST=-4} ## actions on tiles

## non-timeout based states, of the form (state, action): state
var state_machine: Dictionary

## timeout based state transitions, of the form state: (state, time in seconds)
var timer_states: Dictionary = {}

var ag: AutomataGrid ## tile manager model

var pm: PlotMap ## reference to the farm plot, to check ground state

## Initializes the crop map with [param r] rows, [param c] cols, and
## the [param p] farm plot. Returns the initialized object
func data(r: int, c: int, p: PlotMap) -> CropMap:
    rows = r
    cols = c
    pm = p
    return self

## Sets the money checking function ref to be [param money_func]
func set_money_ref(money_func: Callable) -> void:
    money_check = money_func

## Intializes the crop system by algorithmically generating states for
## all crops and does initial renders of all tiles
func _ready() -> void:
    # algorithmically generate growth stages for each crop
    for c in Crop.crop.values():
        if c != Crop.crop.NONE:
            for i in range(STAGES - 1):
                var v = (STAGES-i)*10+c
                # initiate growth
                state_machine[Vector2i(v, actions.TRY_GROW)] = -100*v
                timer_states[-100*v] = Vector2i(-100*v-1, STAGE_TIME)
                # growth checks
                state_machine[Vector2i(-100*v-1, actions.ADVANCE)] = v-10
                state_machine[Vector2i(-100*v-1, actions.FAIL)] = v

            # harvest crop
            state_machine[Vector2i(10+c, actions.HARVEST)] = Crop.crop.NONE

            # plant crop
            state_machine[Vector2i(Crop.crop.NONE, c)] = STAGES*10 + c

    ag = AutomataGrid.new(cols, rows, Crop.crop.NONE, state_machine, timer_states)
    ag.cell_update.connect(_cell_update)

    add_child(ag.get_timer())

## Updates the cell at location ([param x], [param y]) to state [param state]
func _cell_update(x: int, y: int, state: int) -> void:
    if state == Crop.crop.NONE: #clear tile (no crop)
        set_cell(Vector2i(x,y), 0, Vector2i(-1, 0))
    elif state > 0: # crop has grown, try to keep growing
        set_cell(Vector2i(x,y), 0, Vector2i(state / 10, state % 10))
        if pm.is_watered(x,y):
            ag.transition(x,y, actions.TRY_GROW)
    elif pm.is_watered(x,y): # crop has finished its growth check, advance to next stage
        ag.transition(x,y, actions.ADVANCE)
    else: # crop has finished its growth check and failed.
        ag.transition(x,y, actions.FAIL)

## Handles hoe tool press at [param loc] for harvesting crops
func hoe_press(loc: Vector2):
    var a = local_to_map(loc)
    if a.x >= 0 and a.x <= cols and a.y >= 0 and a.y <= rows:
        _try_harvest(a.x,a.y)

## Handles shovel tool press at [param loc] for planting the seed [param _seed]
func shovel_press(loc: Vector2, _seed: Crop.crop) -> void:
    var a = local_to_map(loc)
    if a.x >= 0 and a.x <= cols and a.y >= 0 and a.y <= rows:
        # check if can plant, and has money
        if pm.can_plant(a.x,a.y) and ag.get_tile(a.x,a.y) == 0 \
                and money_check.call() >= Crop.crop_cost[_seed]:
            money_change.emit(-Crop.crop_cost[_seed])
            ag.transition(a.x,a.y, _seed)
        _try_harvest(a.x,a.y)
        Sound.play_sfx(Sound.EFFECT.INTERACT)

## Attempts to harvest a crop at location ([param x], [param y])
func _try_harvest(x: int, y: int) -> void:
    var val = ag.get_tile(x, y)
    # check if crop is harvestable
    if val != 0 and Crop.crop_val.has(val-10):
        val = Crop.crop_val[val-10]

        ag.transition(x,y, actions.HARVEST)
        # check if harvest succeeded
        if ag.get_tile(x, y) == Crop.crop.NONE:
            money_change.emit(val)

## alert the crop system that the ground at location
## ([param x], [param y]) was watered
func got_watered(x: int, y: int):
    ag.transition(x, y, actions.TRY_GROW)

## Handles fertilizer tool press at location [param loc]
## to instantly mature crops (make it harvestable)
func fertilizer_press(loc: Vector2) -> void:
    var a = local_to_map(loc)
    # bounds check
    if a.x >= 0 and a.x < cols and a.y >= 0 and a.y < rows:
        var cur_state: int = ag.get_tile(a.x, a.y)
        if cur_state < 0:
            cur_state = (abs(cur_state) / 100) as int

        if cur_state != 0:
            ag.set_tile(a.x, a.y, (cur_state % 10) + 10) # make crop fully grown
            Sound.play_sfx(Sound.EFFECT.INTERACT)
