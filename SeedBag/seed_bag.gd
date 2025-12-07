class_name SeedBag extends RefCounted
## [SeedBag] is the model for the seed bag. It keeps track of which crop is selected and
## which crops have been unlocked.
##
## Has a signal [signal SeedBag.seed_bag_updated], emitted when the model updates.
## Contains [member SeedBag.money], a reference to the [Money] object used for the game so that
## money can be deducted to unlock crops. Also contains [member SeedBag.current_crop] as a direct
## reference to the currently selected crop. has dictionaries [member SeedBag.seed_states] and
## [member SeedBag.seed_unlocked] for the selection and unlock states of all crops.

## A signal emitted when the SeedBag model updates.
signal seed_bag_updated()

## A reference to the [Money] object for the game.
var money: Money
## A reference to the currently selected [constant Crop.crop]. This way code that only cares
## about which crop is selected doesn't have to search the whole dictionary.
var current_crop: Crop.crop = Crop.crop.NONE
## Dictionary that maps Crop types to whether or not they are selected.
## Selected if true, not selected if false.
var seed_states: Dictionary[Crop.crop, bool]
## Dictionary mapping Crop types to whether or not they are unlocked.
## true if the crop has been unlocked, false if the crop still needs to be unlocked.
var seed_unlocked: Dictionary[Crop.crop, bool]


## Initializes the [member SeedBag.seed_states] to all false.
## Initializes the [member SeedBag.seed_unlocked] to all false.
func _init():
    var crop_keys = Crop.crop.keys()
    for i in range(Crop.crop.size()-1): # -1 to not include Crop.crop.NONE
        seed_states[Crop.crop.get(crop_keys[i+1])] = false
    for i in range(Crop.crop.size()-1): # -1 to not include Crop.crop.NONE
        seed_unlocked[Crop.crop.get(crop_keys[i+1])] = false


## Returns the value of [SeedBag.current_crop].
func get_crop() -> Crop.crop:
    return current_crop


## param [param crop]: the [enum Crop.crop] to set as the currently selected crop in the SeedBag.
## No change to the state of the [SeedBag] if [param crop] is [constant Crop.crop.NONE].
## [member SeedBag.current_crop] is only set to [param crop] if it has been unlocked.
## Emits [signal SeedBag.seed_bag_updated] after any updates to model.
func set_crop(crop: Crop.crop) -> void:
    if current_crop != Crop.crop.NONE:
        seed_states[current_crop] = false
    if crop != Crop.crop.NONE && seed_unlocked[crop]:
        current_crop = crop
        seed_states[current_crop] = true
    seed_bag_updated.emit()


## param [param m]: The [Money] object to use for payment when unlocking crops.
## Sets [member SeedBag.money] to [param m].
func set_money(m: Money) -> void:
    money = m


## param [param crop]: The [enum Crop.crop] to try to unlock. Does nothing if the seed is already unlocked
## or if [method Money.get_money] is less than the unlock cost for the crop.
## If the [param crop] is currently locked, remove it's unlock cost from the player's money, and set
## the seed to unlocked. Emits [signal SeedBag.seed_bag_updated].
func unlock_crop(crop: Crop.crop) -> void:
    if seed_unlocked[crop] || money.get_money() < Crop.crop_unlock_cost[crop]:
        return
    money.add_money(-Crop.crop_unlock_cost[crop])
    seed_unlocked[crop] = true
    seed_bag_updated.emit()


## param [param crop]: The [enum Crop.crop] to get the state for. Returns the entry for [param crop]
## in [member SeedBag.seed_states].
func get_seed_state(crop: Crop.crop) -> bool:
    return seed_states[crop]
