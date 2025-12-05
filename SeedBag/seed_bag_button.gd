class_name SeedBagButton extends Button

var crop: Crop.crop = Crop.crop.NONE
var seed_bag: SeedBag

func _on_seed_bag_updated() -> void:
    if seed_bag.seed_unlocked[crop]:
        text = ""
        icon = Crop.crop_texture[crop]
        _modulate_button(seed_bag.get_seed_state(crop))
    else:
        text = "${0}".format(Crop.crop_unlock_cost[crop])

func set_crop(c: Crop.crop) -> void:
    crop = c
    if !seed_bag.seed_unlocked[crop]:
        text = "${0}".format(Crop.crop_unlock_cost[crop])
    else:
        icon = Crop.crop_texture[c]

func set_seed_bag(sb: SeedBag) -> void:
    seed_bag = sb

func _modulate_button(selected: bool) -> void:
    if selected:
        modulate = Color(1,1,0,1)
    else:
        modulate = Color(1,1,1,1)
