extends TileMapLayer
class_name FarmPlot

# Model

const rows: int = 12 ## rows in the tile map
const cols: int = 15 ## columns in the tilemap

enum actions {TILL, WATER} ## actions on tiles

## non-timeout based states, of the form (state, action): state
const state_machine: Dictionary = {
        Vector2i(TileState.GroundType.GRASS, actions.TILL):TileState.GroundType.DIRT,
        Vector2i(TileState.GroundType.DIRT, actions.WATER):TileState.GroundType.WET_DIRT,
    }

## timeout based state transitions, of the form state: (state, time in seconds)
const timer_states: Dictionary = {
        TileState.GroundType.WET_DIRT: Vector2i(TileState.GroundType.DIRT, 5)
    }

## time update state transitions (state, action): (time to add, max time)
const time_update: Dictionary = {
        Vector2i(TileState.GroundType.WET_DIRT, actions.WATER): Vector2i(5,30)
    }

## tile manager model
var tm: TM_Manager

## Growth class 
var growth: Growth

## set-up. Creates a TM_Manager model, does initial renders of all tiles
## actions on tiles
func _ready() -> void:
    
    
    tm = TM_Manager.new(cols, rows, state_machine, timer_states, time_update)
    tm.cell_update.connect(_cell_update)
    for i in range(rows):
        for j in range(cols):
            set_cell(Vector2i(j,i), 0, Vector2i(tm.get_tile(j,i).ground, 0))
            ##growth.set_cell(Vector2i(j,i), 1, Vector2i(tm.get_tile(j,i), 0))
    add_child(tm.get_timer())
    
    growth = Growth.new(self.tile_set, tm);
    add_child(growth);

func get_cell_status(x: int, y: int) -> int:
    var t = local_to_map(Vector2(x,y))
    return tm.get_tile(t.x, t.y).ground

# View

## signal handler to deal with visual updates.
func _cell_update(x: int, y: int, state: TileState) -> void:
    set_cell(Vector2i(x,y), 0, Vector2i(state.ground, 0))

# Controller

## Temporary input handling.
func hoe_press(loc: Vector2):
    var a = local_to_map(to_local(loc))
    if a.x >= 0 and a.x <= cols and a.y >= 0 and a.y <= rows:
        Sound.play_sfx(Sound.EFFECT.INTERACT)
        
        ##If a plant can be harvested, then do it
        tm.try_harvest(a.x, a.y)
        
        tm.apply_ground_transition(a.x,a.y,actions.TILL)

func water_press(loc: Vector2):
    var a = local_to_map(to_local(loc))
    if a.x >= 0 and a.x <= cols and a.y >= 0 and a.y <= rows:
        Sound.play_sfx(Sound.EFFECT.INTERACT)
        tm.apply_ground_transition(a.x,a.y,actions.WATER)

func shovel_press(loc: Vector2, _seed: GameManager.sc) -> void:
    var a = local_to_map(to_local(loc))
    tm.try_harvest(a.x,a.y)

