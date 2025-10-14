extends TileMapLayer

# Model

const rows: int = 20
const cols: int = 10

enum {GRASS=0, DIRT=1, WET_DIRT=2}
enum actions {TILL, WATER}

const state_machine: Dictionary = {
        Vector2i(GRASS, actions.TILL):DIRT,
        Vector2i(DIRT, actions.WATER):WET_DIRT,
    }

const timer_states: Dictionary = {
        WET_DIRT: Vector2i(DIRT, 5)
    }

var tm: TM_Manager

func _ready() -> void:
    tm = TM_Manager.new(rows, cols, GRASS, state_machine, timer_states)
    tm.cell_update.connect(_cell_update)
    for i in range(rows):
        for j in range(cols):
            set_cell(Vector2i(i,j), 0, Vector2i(tm.get_tile(i,j), 0))
    add_child(tm.get_timer())

# View

func _cell_update(x: int, y: int, state) -> void:
    set_cell(Vector2i(x,y), 0, Vector2i(state, 0))

# Controller

func _input(event) -> void:
    if event.is_action_pressed("click"):
        var a = local_to_map(event.get_position())
        tm.apply_transition(a.x,a.y,actions.TILL)

    if event.is_action_pressed("hotkey_1"):
        var a = local_to_map(get_viewport().get_mouse_position())
        tm.apply_transition(a.x,a.y,actions.WATER)
