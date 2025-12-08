extends GutTest

## test init (and implicitly get_rows,get_cols,get_tile,get_timer
func test_init() -> void:
    var ag: AutomataGrid = AutomataGrid.new(2,2)
    assert_ne(ag, null)
    assert_eq(ag.get_rows(), 2)
    assert_eq(ag.get_cols(), 2)
    assert_eq(ag.get_tile(0,0), 0)
    assert_eq(ag.get_tile(1,0), 0)
    assert_eq(ag.get_tile(0,1), 0)
    assert_eq(ag.get_tile(1,1), 0)
    assert_eq(ag.get_tile(-1,1), -1)
    assert_eq(ag.get_tile(-1,-1), -1)
    assert_eq(ag.get_tile(1,-1), -1)
    assert_eq(ag.get_tile(0,2), -1)
    assert_ne(ag.get_timer(), null)

    ag = AutomataGrid.new(2,2, 1)
    assert_ne(ag, null)
    assert_eq(ag.get_rows(), 2)
    assert_eq(ag.get_cols(), 2)
    assert_eq(ag.get_tile(0,0), 1)
    assert_eq(ag.get_tile(1,0), 1)
    assert_eq(ag.get_tile(0,1), 1)
    assert_eq(ag.get_tile(1,1), 1)
    assert_eq(ag.get_tile(-1,1), -1)
    assert_eq(ag.get_tile(-1,-1), -1)
    assert_eq(ag.get_tile(1,-1), -1)
    assert_eq(ag.get_tile(0,2), -1)

    # dummy state machines just to test that they are set
    ag = AutomataGrid.new(2,2,0, {5:1}, {4:1}, {3:1})
    assert_eq(ag.states[5], 1)
    assert_eq(ag.timer_states[4], 1)
    assert_eq(ag.time_update[3], 1)

## test setting tiles explicitely
func test_set_tile() -> void:
    var ag: AutomataGrid = AutomataGrid.new(2,2)
    assert_eq(ag.get_tile(0,0), 0)
    assert_eq(ag.get_tile(1,0), 0)
    assert_eq(ag.get_tile(0,1), 0)
    assert_eq(ag.get_tile(1,1), 0)
    assert_eq(ag.get_tile(-1,1), -1)

    ag.set_tile(0,0, 1)
    assert_eq(ag.get_tile(0,0), 1)
    assert_eq(ag.get_tile(1,0), 0)
    assert_eq(ag.get_tile(0,1), 0)
    assert_eq(ag.get_tile(1,1), 0)
    assert_eq(ag.get_tile(-1,1), -1)

    ag.set_tile(1,1, 2)
    assert_eq(ag.get_tile(0,0), 1)
    assert_eq(ag.get_tile(1,0), 0)
    assert_eq(ag.get_tile(0,1), 0)
    assert_eq(ag.get_tile(1,1), 2)
    assert_eq(ag.get_tile(-1,1), -1)

    ag.set_tile(0,0, 2)
    assert_eq(ag.get_tile(0,0), 2)
    assert_eq(ag.get_tile(1,0), 0)
    assert_eq(ag.get_tile(0,1), 0)
    assert_eq(ag.get_tile(1,1), 2)
    assert_eq(ag.get_tile(-1,1), -1)

    ag.set_tile(0,-1, 1)
    assert_eq(ag.get_tile(0,0), 2)
    assert_eq(ag.get_tile(1,0), 0)
    assert_eq(ag.get_tile(0,1), 0)
    assert_eq(ag.get_tile(1,1), 2)
    assert_eq(ag.get_tile(-1,1), -1)

## test set_timer_state_machine
func test_set_timer_state_machine() -> void:
    var ag: AutomataGrid = AutomataGrid.new(2,2)
    # dummy state machines just to test that they are set
    ag.set_timer_state_machine({5:1})
    assert_eq(ag.timer_states[5], 1)


## test sets_state_machine
func test_set_state_machine() -> void:
    var ag: AutomataGrid = AutomataGrid.new(2,2)
    # dummy state machines just to test that they are set
    ag.set_state_machine({5:1})
    assert_eq(ag.states[5], 1)

## test cell_update when setting tile
func test_cell_update_signal() -> void:
    var ag: AutomataGrid = AutomataGrid.new(2,2)

    var update_check = func (x, y, s):
        assert_eq(ag.get_tile(x,y), s)
        assert_eq(ag.get_tile(x,y), 1)

    ag.cell_update.connect(update_check)

    ag.set_tile(0,0, 1)
    assert_eq(ag.get_tile(0,0), 1)

    ag.set_tile(1,0, 1)
    assert_eq(ag.get_tile(0,0), 1)

    ag.set_tile(0,1, 1)
    assert_eq(ag.get_tile(0,0), 1)

    ag.set_tile(1,1, 1)
    assert_eq(ag.get_tile(0,0), 1)

## test cell_update when transitioning tile
func test_transition() -> void:
    var ag: AutomataGrid = AutomataGrid.new(2,2)

    var update_check = func (x, y, s):
        assert_eq(ag.get_tile(x,y), s)
    ag.cell_update.connect(update_check)

    var states = {
        Vector2i(0, 1): 1,
        Vector2i(1, 1): 2,
        Vector2i(1, 2): 3,
    }
    ag.set_state_machine(states)

    ag.transition(0,0, 1)
    assert_eq(ag.get_tile(0,0), 1)

    ag.transition(1,0, 1)
    assert_eq(ag.get_tile(1,0), 1)

    ag.transition(0,0, 1)
    assert_eq(ag.get_tile(0,0), 2)

    ag.transition(1,0, 2)
    assert_eq(ag.get_tile(1,0), 3)

