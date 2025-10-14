class_name TM_Manager
extends RefCounted

const TIMEOUT: float = 0.1
const TIMEOUT_FACTOR: int = 10

var cols: int
var rows: int
var tile_data: Array[int] = []

# (state: int, action: int): state:int
var states: Dictionary

signal cell_update(x: int, y: int, state: int)

var timer: Timer

# (state: int): (state:int, time: int)
var timer_states: Dictionary

# (x, y): (start_state, time_remaining)
var current_timers: Dictionary

func _init(x: int, y: int, init_state: int = 0, state_machine: Dictionary = {}, timer_state_machine = {}) -> void:
    cols = x
    rows = y
    for a in range(cols * rows):
        tile_data.append(init_state)
    states = state_machine.duplicate()
    timer_states = timer_state_machine.duplicate()

    timer = Timer.new()
    timer.one_shot = false
    timer.autostart = true
    timer.timeout.connect(_handle_time)
    timer.wait_time = TIMEOUT

func apply_transition(x: int, y: int, t: int):
    if x >= 0 and y >= 0 and x < cols and y < rows:
        var idx = x + y*cols
        if states.has(Vector2i(tile_data[idx], t)):
            var new_s: int = states[Vector2i(tile_data[idx], t)]
            tile_data[idx] = new_s
            if timer_states.has(new_s):
                current_timers[Vector2i(x,y)] = Vector2i(new_s, timer_states[new_s].y* TIMEOUT_FACTOR)
            cell_update.emit(x,y,tile_data[idx])

func _handle_time() -> void:
    for cell in current_timers.keys():
        if current_timers[cell].y == 0:
            var idx: int = cell.x + cell.y * cols
            if current_timers[cell].x == tile_data[idx]:
                tile_data[idx] = timer_states[tile_data[idx]].x
                cell_update.emit(cell.x,cell.y,tile_data[idx])
            current_timers.erase(cell)
        if current_timers.has(cell):
            current_timers[cell] -= Vector2i(0,1)

#setters/getters
func get_timer() -> Timer:
    return timer

func set_state_machine(state_machine: Dictionary) -> void:
    states = state_machine.duplicate()

func set_timer_state_machine(state_machine: Dictionary) -> void:
    timer_states = state_machine.duplicate()

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
