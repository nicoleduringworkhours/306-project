extends TileMapLayer

# Model

const rows: int = 20 ## rows in the tile map
const cols: int = 10 ## columns in the tilemap

enum {GRASS=0, DIRT=1, WET_DIRT=2} ## States of tiles
enum actions {TILL, WATER} ## actions on tiles

## non-timeout based states, of the form (state, action): state
const state_machine: Dictionary = {
        Vector2i(GRASS, actions.TILL):DIRT,
        Vector2i(DIRT, actions.WATER):WET_DIRT,
    }

## timeout based state transitions, of the form state: (state, time in seconds)
const timer_states: Dictionary = {
        WET_DIRT: Vector2i(DIRT, 5)
    }

## time update state transitions (state, action): (time to add, max time)
const time_update: Dictionary = {
        Vector2i(WET_DIRT, actions.WATER): Vector2i(5,30)
    }

## tile manager model
var tm: TM_Manager

## set-up. Creates a TM_Manager model, does initial renders of all tiles
## actions on tiles
func _ready() -> void:
    tm = TM_Manager.new(cols, rows, GRASS, state_machine, timer_states, time_update)
    tm.cell_update.connect(_cell_update)
    for i in range(rows):
        for j in range(cols):
            set_cell(Vector2i(j,i), 0, Vector2i(tm.get_tile(j,i), 0))
    add_child(tm.get_timer())

# View

## signal handler to deal with visual updates.
func _cell_update(x: int, y: int, state) -> void:
    set_cell(Vector2i(x,y), 0, Vector2i(state, 0))

# Controller

## Temporary input handling.
func _input(event) -> void:
    # temporary input handling for testing.
    if event.is_action_pressed("click"):
        var a = local_to_map(event.get_position())
        tm.apply_transition(a.x,a.y,actions.TILL)

    if event.is_action_pressed("hotkey_1"):
        var a = local_to_map(get_viewport().get_mouse_position())
        tm.apply_transition(a.x,a.y,actions.WATER)
