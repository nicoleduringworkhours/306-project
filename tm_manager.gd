class_name TM_Manager
extends RefCounted

var rows: int
var cols: int
var tile_data: Array[int] = []
var states: Dictionary

func _init(x: int, y: int, init_state: int = 0, state_machine: Dictionary = {}) -> void:
    rows = x
    cols = y
    for i in range(rows):
        for j in range(cols):
            tile_data.append(init_state)
    states = state_machine.duplicate()

func apply_transition(x: int, y: int, t: int) -> int:
    if x >= 0 and y >= 0 and x < rows and y < cols:
        var idx = x*cols + y
        if states.has(Vector2i(tile_data[idx], t)):
            tile_data[idx] = states[Vector2i(tile_data[idx], t)]
        return tile_data[idx]
    return -1

#setters/getters
func set_state_machine(state_machine: Dictionary) -> void:
    states = state_machine.duplicate()

func get_tile(x: int, y: int) -> int:
    if x >= 0 and y >= 0 and x < rows and y < cols:
        return tile_data[x*cols + y]
    else:
        return -1

func get_tile_v(v: Vector2i) -> int:
    if v.x >= 0 and v.y >= 0 and v.x < rows and v.y < cols:
        return tile_data[v.x*cols + v.y]
    else:
        return -1

func set_tile(x: int, y: int, state: int) -> void:
    if x >= 0 and y >= 0 and x < rows and y < cols:
        tile_data[x*cols + y] = state

func set_tile_v(v: Vector2i, state: int) -> void:
    if v.x >= 0 and v.y >= 0 and v.x < rows and v.y < cols:
        tile_data[v.x*cols + v.y] = state

func get_rows() -> int:
    return rows

func get_cols() -> int:
    return cols
