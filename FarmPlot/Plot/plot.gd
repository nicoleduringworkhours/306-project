class_name PlotMap
extends TileMapLayer

# Model

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

func data(r: int, c: int) -> PlotMap:
    rows = r
    cols = c
    return self

## set-up. Creates a TM_Manager model, does initial renders of all tiles
## actions on tiles
func _ready() -> void:
    ag = AutomataGrid.new(cols, rows, GRASS, state_machine, timer_states, time_update)
    ag.cell_update.connect(_cell_update)
    for i in range(rows):
        for j in range(cols):
            set_cell(Vector2i(j,i), 0, Vector2i(ag.get_tile(j,i), 0))
    add_child(ag.get_timer())

func get_cell_status(x: int, y: int) -> int:
    var t = local_to_map(Vector2(x,y))
    return ag.get_tile(t.x, t.y)

func can_plant(x: int, y: int) -> bool:
    return ag.get_tile(x,y) != GRASS

func is_watered(x: int, y: int) -> bool:
    return ag.get_tile(x,y) == WET_DIRT

# View

## signal handler to deal with visual updates.
signal got_watered(x: int, y: int)

func _cell_update(x: int, y: int, state) -> void:
    set_cell(Vector2i(x,y), 0, Vector2i(state, 0))
    if state == WET_DIRT:
        got_watered.emit(x, y)

# Controller

func hoe_press(loc: Vector2):
    var a = local_to_map(loc)
    if a.x >= 0 and a.x <= cols and a.y >= 0 and a.y <= rows:
        Sound.play_sfx(Sound.EFFECT.INTERACT)
        ag.transition(a.x,a.y,actions.TILL)

func water_press(loc: Vector2):
    var a = local_to_map(loc)
    if a.x >= 0 and a.x <= cols and a.y >= 0 and a.y <= rows:
        Sound.play_sfx(Sound.EFFECT.INTERACT)
        ag.transition(a.x,a.y,actions.WATER)
