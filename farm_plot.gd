extends TileMapLayer

var tm: TM_Manager

var rows: int = 10
var cols: int = 10

enum {GRASS=0, DIRT=1, WET_DIRT=2}
enum actions {TILL, WATER}

const state_machine: Dictionary = {
        Vector2i(GRASS, actions.TILL):DIRT,
        Vector2i(DIRT, actions.WATER):WET_DIRT,
    }

func _process(_delta: float):
    for i in range(rows):
        for j in range(cols):
            _cell_change(i, j)

func _ready():
    tm = TM_Manager.new(rows,cols, GRASS, state_machine)
    for i in range(rows):
        for j in range(cols):
            _cell_change(i, j)

func _input(event) -> void:
    if event.is_action_pressed("click"):
        var a = local_to_map(event.get_position())
        #print(a)
        tm.apply_transition(a.x,a.y,actions.TILL)
        #_cell_change(a.x,a.y)

func _cell_change(x: int, y: int) -> void:
    set_cell(Vector2i(x,y), 0, Vector2i(tm.get_tile(x,y), 0))
