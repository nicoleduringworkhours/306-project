class_name SeedBag

signal seed_bag_updated()

var money: Money
## A reference to the currently selected crop. This way code that only cares
## about which crop is selected doesn't have to search the whole dictionary.
var current_crop: Crop.crop = Crop.crop.NONE
## Dictionary that maps Crop types to whether or not they are selected.
## Selected if true, not selected if false.
var seed_states: Dictionary[Crop.crop, bool]
## TODO: Document
var seed_unlocked: Dictionary[Crop.crop, bool]

func _init():
    var crop_keys = Crop.crop.keys()
    for i in range(Crop.crop.size()-1): # -1 to not include Crop.crop.NONE
        seed_states[Crop.crop.get(crop_keys[i+1])] = false
    for i in range(Crop.crop.size()-1): # -1 to not include Crop.crop.NONE
        seed_unlocked[Crop.crop.get(crop_keys[i+1])] = false

func get_crop() -> Crop.crop:
    return current_crop

func set_crop(crop: Crop.crop) -> void:
    if current_crop != Crop.crop.NONE:
        seed_states[current_crop] = false
    if crop != Crop.crop.NONE && seed_unlocked[crop]:
        current_crop = crop
        seed_states[current_crop] = true
    seed_bag_updated.emit()

func set_money(m: Money) -> void:
    money = m

func unlock_crop(crop: Crop.crop) -> void:
    if seed_unlocked[crop] || money.get_money() < Crop.crop_unlock_cost[crop]:
        return
    money.add_money(-Crop.crop_unlock_cost[crop])
    seed_bag_updated.emit()
