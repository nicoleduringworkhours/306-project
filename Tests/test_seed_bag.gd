extends GutTest


func test_constructor():
    var seed_bag: SeedBag = SeedBag.new()
    assert_eq(seed_bag.seed_states.size(), 9)
    assert_eq(seed_bag.seed_unlocked.size(), 9)
    assert_false(seed_bag.seed_states.values().has(true))
    assert_false(seed_bag.seed_unlocked.values().has(true))
    assert_eq(seed_bag.current_crop, Crop.crop.NONE)


func test_getters():
    var seed_bag: SeedBag = SeedBag.new()
    assert_eq(seed_bag.get_crop(), Crop.crop.NONE)
    seed_bag.current_crop = Crop.crop.CORN
    assert_eq(seed_bag.get_crop(), Crop.crop.CORN)
    assert_false(seed_bag.get_seed_state(Crop.crop.BEAN))
    seed_bag.seed_states[Crop.crop.BEAN] = true
    assert_true(seed_bag.get_seed_state(Crop.crop.BEAN))


func test_setters():
    var seed_bag: SeedBag = SeedBag.new()
    var money: Money = load("res://HUD/money_hud.tscn").instantiate()
    seed_bag.set_crop(Crop.crop.TOMATO)
    assert_eq(seed_bag.current_crop, Crop.crop.NONE)
    assert_false(seed_bag.seed_states[Crop.crop.TOMATO])
    seed_bag.seed_unlocked[Crop.crop.TOMATO] = true
    seed_bag.set_crop(Crop.crop.TOMATO)
    assert_eq(seed_bag.current_crop, Crop.crop.TOMATO)
    assert_true(seed_bag.seed_states[Crop.crop.TOMATO])
    # Test set_money
    seed_bag.set_money(money)
    assert_eq(seed_bag.money, money)


func test_unlocking():
    var seed_bag: SeedBag = SeedBag.new()
    var money: Money = load("res://HUD/money_hud.tscn").instantiate()
    seed_bag.set_money(money)
    # Test can afford unlock
    seed_bag.unlock_crop(Crop.crop.BEAN)
    assert_true(seed_bag.seed_unlocked[Crop.crop.BEAN])
    # Test can't afford unlock
    seed_bag.unlock_crop(Crop.crop.TOMATO)
    assert_false(seed_bag.seed_unlocked[Crop.crop.TOMATO])
    # Test money is removed
    seed_bag.unlock_crop(Crop.crop.WHEAT)
    assert_true(seed_bag.seed_unlocked[Crop.crop.WHEAT])
    assert_eq(money.get_money(), 0)
