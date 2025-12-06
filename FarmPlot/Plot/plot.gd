class_name PlotMap
extends TileMapLayer

## The rows and columns in the farm plot
var rows: int
var cols: int

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
var ag: AutomataGrid

## initialize the plot map [param r] rows and [param c] cols
## returns initialized plot map
func data(r: int, c: int) -> PlotMap:
    rows = r
    cols = c
    return self

## set-up. Creates a TM_Manager model, does initial renders of all tiles
## actions on tiles
func _ready() -> void:
    # init automata grid for the model
    ag = AutomataGrid.new(cols, rows, GRASS, state_machine, timer_states, time_update)
    ag.cell_update.connect(_cell_update)
    for i in range(rows):
        for j in range(cols):
            set_cell(Vector2i(j,i), 0, Vector2i(ag.get_tile(j,i), 0))
    add_child(ag.get_timer())

## get the cell state at location ([param x], [param y])
func get_cell_status(x: int, y: int) -> int:
    var t = local_to_map(Vector2(x,y))
    return ag.get_tile(t.x, t.y)

## returns true iff you can plant a crop at location ([param x],[param y])
func can_plant(x: int, y: int) -> bool:
    return ag.get_tile(x,y) != GRASS

## returns true iff the tile at location ([param x],[param y]) is watered
func is_watered(x: int, y: int) -> bool:
    return ag.get_tile(x,y) == WET_DIRT

## emitted when a tile at loc ([param x],[param y]) becomes watered
signal got_watered(x: int, y: int)

## signal handler to deal with visual updates of the tile at location
## ([param x], [param y]) in state [param state]
func _cell_update(x: int, y: int, state) -> void:
    set_cell(Vector2i(x,y), 0, Vector2i(state, 0))
    if state == WET_DIRT:
        got_watered.emit(x, y)

## handle hoe press at location [param loc]
func hoe_press(loc: Vector2):
    var a = local_to_map(loc)
    # valid press
    if a.x >= 0 and a.x <= cols and a.y >= 0 and a.y <= rows:
        Sound.play_sfx(Sound.EFFECT.INTERACT)
        ag.transition(a.x,a.y,actions.TILL)

## handle watering can press at location [param loc]
func water_press(loc: Vector2):
    var a = local_to_map(loc)
    # valid press
    if a.x >= 0 and a.x <= cols and a.y >= 0 and a.y <= rows:
        Sound.play_sfx(Sound.EFFECT.INTERACT)
        ag.transition(a.x,a.y,actions.WATER)
