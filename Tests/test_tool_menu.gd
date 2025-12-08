extends GutTest

#assert_ne(roller, null)
#assert_eq(roller.get_n_dice(), 1)
#assert_gte(roll[i], 1)
#assert_lte(roll[i], 5)

## test creation and timer initialization
## test set_money_check and set/get_tool
func test_init():
    var t: ToolModel = ToolModel.new()

    assert_ne(t.get_timer(), null)
    t.set_tool(t.tools.SHOVEL)
    assert_eq(t.get_tool(), t.tools.SHOVEL)

    t.set_tool(t.tools.HOE)
    assert_eq(t.get_tool(), t.tools.HOE)

# test switch_tool
func test_switch_tool():
    var t: ToolModel = ToolModel.new()
    t.set_tool(t.tools.SHOVEL)
    assert_eq(t.get_tool(), t.tools.SHOVEL)

    t.switch_tool(1)
    assert_eq(t.get_tool(), t.tools.WATERING_CAN)

    t.switch_tool(2)
    assert_eq(t.get_tool(), t.tools.FERTILIZER)

    t.switch_tool(-1)
    assert_eq(t.get_tool(), t.tools.HOE)

# test unlock_fertilizer and fertilizer_unlocked
func test_fertilizer():
    var t: ToolModel = ToolModel.new()

    var x = func() -> int:
        return 50
    t.set_money_check(x)
    add_child(t.get_timer())

    t.unlock_fertilizer()
    assert_eq(t.fertilizer_unlocked(), true)

    t = ToolModel.new()
    var y = func() -> int:
        return 20
    t.set_money_check(y)
    add_child(t.get_timer())

    t.unlock_fertilizer()
    assert_eq(t.fertilizer_unlocked(), false)
