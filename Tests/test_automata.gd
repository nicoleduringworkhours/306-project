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


## test setting tiles explicitely
func test_set_tile() -> void:
    pass

## test set_timer_state_machine
func test_set_timer_state_machine() -> void:
    pass

## test sets_state_machine
func test_set_state_machine() -> void:
    pass

## test cell_update
func test_cell_update_signal() -> void:
    pass

## test transition (and implicitly cell_update
func test_transition() -> void:
    pass

#assert_ne(roller, null)
#assert_eq(roller.get_n_dice(), 1)
#assert_gte(roll[i], 1)
#assert_lte(roll[i], 5)
