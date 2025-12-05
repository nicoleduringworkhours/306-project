extends TileMapLayer
class_name CropMap

##Manages crop growth, planting and harvesting on tilemap grid
## CropMap uses AutomataGrid to manage crop growth and transitions. The crop
## system uses the following encoding for each crop state:
## 0: Empty
##  > 0 (XY): x = crop stage, Y = crop type
## Negative values : timer-based growth states

# Controller signals
signal seed_planted(crop_type: Crop.crop)

# Model
## number of rows in crop grid
var rows: int

## number of columns in crop grid
var cols: int

## total number of growth stages for crops 
const STAGES: int = 5

## time in seconds for each growth stage
const STAGE_TIME: int = 2

## reference to check if player has enough money for planting
var money_check: Callable

enum actions {ADVANCE=-1, FAIL=-2, TRY_GROW=-3, HARVEST=-4} ## actions on tiles

## non-timeout based states, of the form (state, action): state
var state_machine: Dictionary

## timeout based state transitions, of the form state: (state, time in seconds)
var timer_states: Dictionary = {}

## tile manager model
var ag: AutomataGrid

##plotmap ref
var pm: PlotMap

## Initializes the crop map dimensions and plot ref
## @param r : number of rows in the grid
## @param c : number of cols in the grid
## @param p : ref to the plotmap

## @return : return self
func data(r: int, c: int, p: PlotMap) -> CropMap:
    rows = r
    cols = c
    pm = p
    return self

## Sets the money checking function ref
## @param money_func : returns true if player can afford crop costs
func set_money_ref(money_func: Callable) -> void:
    money_check = money_func

## Intializes the crop system and automata grid, creates all state transitions
## for each crop type and growth stage and connects visual update signals.
## Creates a TM_Manager model, does initial renders of all tiles
## actions on tiles
func _ready() -> void:
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

# View

## Updates tilemap when crop changes and calls for growth transitions for
## watered crops.
## @param x : column coord of the cell
## @param y : row coord of the cell
## @param state : new state value of the cell

func _cell_update(x: int, y: int, state: int) -> void:
    if state == Crop.crop.NONE:
        #clear tile (no crop)
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

## emitted when player money should change
signal money_change(val: int)

## Handles hoe tool for harvesting crops
## @param loc : world position where hoe was used
func hoe_press(loc: Vector2):
    var a = local_to_map(loc)
    if a.x >= 0 and a.x <= cols and a.y >= 0 and a.y <= rows:
        _try_harvest(a.x,a.y)

## Handles shovel tool for planting seeds.
## Plants a seed if the location meets all the required conditions including
## being able to afford the seed.
## @param loc : world position where shoevel was used
## @param __seed : type of crop to plant

func shovel_press(loc: Vector2, _seed: Crop.crop) -> void:
    var a = local_to_map(loc)
    if a.x >= 0 and a.x <= cols and a.y >= 0 and a.y <= rows:
        # check if can plant
        if pm.can_plant(a.x,a.y) and ag.get_tile(a.x,a.y) == 0 \
                and money_check.call() >= Crop.crop_cost[_seed]:
            money_change.emit(-Crop.crop_cost[_seed])
            ag.transition(a.x,a.y, _seed)
        _try_harvest(a.x,a.y)
    #Sound.play_sfx(Sound.EFFECT.INTERACT)

## Attempts to harvest a given crop. This will only succeed if the crop is
## harvestable. Emits money_change signal with crop value on successful harvest
## @param x : col coord of the crop
## @param y : row coord of the crop

func _try_harvest(x: int, y: int):
    var val = ag.get_tile(x, y)
    # check if crop is harvestable
    if val != 0 and Crop.crop_val.has(val-10):
        val = Crop.crop_val[val-10]

        ag.transition(x,y, actions.HARVEST)
        # check if harvest succeeded
        if ag.get_tile(x, y) == Crop.crop.NONE: # harvest success
            money_change.emit(val) #emit signal to add money

## Notifies the crop system that a tile was watered leading to a growth attempt
## at that location.
## @param x : col coord of the tile
## @param y : row coord of the tile
func got_watered(x: int, y: int):
    ag.transition(x, y, actions.TRY_GROW)

## Handles fertilizer tool to instantly mature crops (make it harvestable)
## @param loc : world position where fertilizer was applied

func fertilizer_press(loc: Vector2) -> void:
    var a = local_to_map(loc)
    # bounds check
    if a.x >= 0 and a.x < cols and a.y >= 0 and a.y < rows:
        var cur_state: int = ag.get_tile(a.x, a.y)
        
        if cur_state < 0:
            cur_state = (abs(cur_state) / 100) as int

        if cur_state != 0:
            ## make crop fully grown
            ag.set_tile(a.x, a.y, (cur_state % 10) + 10) 
            Sound.play_sfx(Sound.EFFECT.INTERACT)
