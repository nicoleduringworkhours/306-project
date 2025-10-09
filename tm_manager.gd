class_name TM_Manager
extends RefCounted

var cols: int
var rows: int
var tile_data: Array[int] = []
var states: Dictionary

func _init(x: int, y: int, init_state: int = 0, state_machine: Dictionary = {}) -> void:
    cols = x
    rows = y
    for a in range(cols * rows):
        tile_data.append(init_state)
    states = state_machine.duplicate()

func apply_transition(x: int, y: int, t: int) -> int:
    if x >= 0 and y >= 0 and x < cols and y < rows:
        var idx = x + y*cols
        if states.has(Vector2i(tile_data[idx], t)):
            tile_data[idx] = states[Vector2i(tile_data[idx], t)]
        return tile_data[idx]
    return -1

#setters/getters
func set_state_machine(state_machine: Dictionary) -> void:
    states = state_machine.duplicate()

func get_tile(x: int, y: int) -> int:
    if x >= 0 and y >= 0 and x < cols and y < rows:
        return tile_data[x + y*cols]
    else:
        return -1

func set_tile(x: int, y: int, state: int) -> void:
    if x >= 0 and y >= 0 and x < cols and y < rows:
        tile_data[x + y*cols] = state

func get_cols() -> int:
    return cols

func get_rows() -> int:
    return rows
