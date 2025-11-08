class_name TM_Manager
extends RefCounted

const TIMEOUT: int = 10 ## times/sec to check for timeout.

var cols: int ## number of columns (x-dimension)
var rows: int ## number of rows (y-dimension)

var tile_data: Array[TileState] = [] ## 1D array of tile data

## State machine dictating which actions change which states into
## which others, entries must be of the form
## (initial_state: int, action: int): destination_state: int
var states: Dictionary

## signals when a cell updates, transmits which cell changed, and what to
signal cell_update(x: int, y: int, state: TileState)
signal get_money(x: int)

## timer for timeout states. must be added to scene tree with
## get_timer if it will be used
var timer: Timer

## State machine dictating the timeouts for states
## if a cell transitions into a state, a timeout will be started, and
## if the cell is still in the same state when the timeout completes,
## it will automatically change to a different state
## entries of the form (entry_state: int): (end_state:int, time_in_seconds: int)
var timer_states: Dictionary

## the states currently in a timeout state
## entries of the form (x: int, y: int): (start_state: int, time_remaining: int)
var current_timers: Dictionary

## the states which handle timer update transitions
## entries of the form (state: int, action: int): (time_to_add: int, max_time: int)
var time_update: Dictionary

## initialize the tile manager
## [param x] the number of columns for the tile map
## [param y] the number of rows for the tile map
## [param state_machine] optional parameter for how states transition
##      by action, default is no transitions. can be set later.
## [param timer_state_machine] optional parameter for how states
##      transition on timeout, default is no transitions, can be set later
func _init(x: int, y: int, state_machine: Dictionary = {}, timer_state_machine = {}, timer_update = {}) -> void:
    cols = x
    rows = y
    for a in range(cols * rows):
        tile_data.append(TileState.new(TileState.GroundType.GRASS, -1, 0.0));
    states = state_machine.duplicate()
    timer_states = timer_state_machine.duplicate()
    time_update = timer_update.duplicate()

    timer = Timer.new()
    timer.one_shot = false
    timer.autostart = true
    timer.timeout.connect(_handle_time)
    timer.wait_time = 1.0/TIMEOUT

## Apply an action to a cell
## [param x] x coordinate of the cell
## [param y] y coordinate of the cell
## [param t] the transition to apply
func apply_ground_transition(x: int, y: int, t: int):
    # valid cell
    if x >= 0 and y >= 0 and x < cols and y < rows:
        var idx = x + y*cols
        var state_key = Vector2i(tile_data[idx].ground, t)
        var pos = Vector2i(x,y)

        #tile_data[idx].ground = TileState.GroundType.DIRT;
        #cell_update.emit(x,y,tile_data[idx])
        # valid action
        if states.has(state_key):
            # update
            var new_s: TileState.GroundType = states[state_key]
            tile_data[idx].ground = new_s
            # start timer if needed
            if timer_states.has(new_s):
                current_timers[pos] = Vector2i(new_s, timer_states[new_s].y* TIMEOUT)

            cell_update.emit(x,y,tile_data[idx])

        # valid time update
        elif time_update.has(state_key) and current_timers.has(pos):
            current_timers[pos].y = clamp(current_timers[pos].y + time_update[state_key].x*TIMEOUT, 0, time_update[state_key].y*TIMEOUT)

## Apply an action to a cell
## [param x] x coordinate of the cell
## [param y] y coordinate of the cell
## [param s] seed id
## [param g] starting growth (presumably, always 0.0)
func plant_seed(x: int, y: int, s: int, g = 0.0):
    # valid cell
    if x >= 0 and y >= 0 and x < cols and y < rows:
        var idx = x + y*cols
        ##Can't plant seeds in grass
        ##Can't plant seeds if tile already has seed also
        if  tile_data[idx].ground == TileState.GroundType.GRASS \
        or tile_data[idx].seed_type != -1:
            return
        ##Change tile stats and continue
        tile_data[idx].seed_type = s
        tile_data[idx].growth = g
        cell_update.emit(x,y, tile_data[idx])

## Apply an action to a cell
## [param x] x coordinate of the cell
## [param y] y coordinate of the cell
func try_harvest(x: int, y: int) -> bool:
    # valid cell
    if x >= 0 and y >= 0 and x < cols and y < rows:
        var idx = x + y*cols
        ##Can't plant seeds in grass
        if tile_data[idx].growth < 0.99:
            return false
        ##Change tile stats and continue
        tile_data[idx].seed_type = -1
        tile_data[idx].growth = 0.0
        ##var amogus = get_node("farmplot")
        ##amogus.add_money(5)
        get_money.emit(5)
        cell_update.emit(x,y, tile_data[idx])
        return true
    return false

## check for cell timeouts for any cells registered with a timeout.
func _handle_time() -> void:
    for cell in current_timers.keys():

        ##Handle increasing growth (this could be optimized later?)
        var idxt: int = cell.x + cell.y * cols
        ##This should be correct, no?
        tile_data[idxt].stimulate_growth(1.0 / TIMEOUT);
        cell_update.emit(cell.x,cell.y,tile_data[idxt]);

        if current_timers[cell].y == 0: # timed out
            var idx: int = cell.x + cell.y * cols
            # state has not changed since timer start
            if current_timers[cell].x == tile_data[idx].ground:
                # update state and signal update
                tile_data[idx].ground = timer_states[tile_data[idx].ground].x
                cell_update.emit(cell.x,cell.y,tile_data[idx])

            # remove from timer tracking.
            current_timers.erase(cell)

        else: # not timed out so count down
            current_timers[cell] -= Vector2i(0,1)

#setters/getters below

func get_timer() -> Timer:
    return timer

func set_state_machine(state_machine: Dictionary) -> void:
    states = state_machine.duplicate()

func set_timer_state_machine(state_machine: Dictionary) -> void:
    timer_states = state_machine.duplicate()

func get_tile(x: int, y: int) -> TileState:
    if x >= 0 and y >= 0 and x < cols and y < rows:
        return tile_data[x + y*cols]
    else:
        return null

func set_tile(x: int, y: int, state: TileState) -> void:
    if x >= 0 and y >= 0 and x < cols and y < rows:
        tile_data[x + y*cols] = state

func get_cols() -> int:
    return cols

func get_rows() -> int:
    return rows
