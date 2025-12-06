class_name SeedBagButton extends Button

var crop: Crop.crop = Crop.crop.NONE
var seed_bag: SeedBag

func _on_seed_bag_updated() -> void:
    if seed_bag.seed_unlocked[crop]:
        set_button_icon(Crop.crop_texture[crop])
        set_text("$"+str(Crop.crop_cost[crop]))
        _modulate_button(seed_bag.get_seed_state(crop))
    else:
        set_button_icon(Crop.crop_texture[Crop.crop.NONE])
        set_text("$"+str(Crop.crop_unlock_cost[crop]))
        _modulate_button(seed_bag.get_seed_state(crop))

func set_crop(c: Crop.crop) -> void:
    crop = c
    set_button_icon(Crop.crop_texture[Crop.crop.NONE])
    set_text("$"+str(Crop.crop_unlock_cost[crop]))

func set_seed_bag(sb: SeedBag) -> void:
    seed_bag = sb
    seed_bag.seed_bag_updated.connect(_on_seed_bag_updated)

func _modulate_button(selected: bool) -> void:
    if selected:
        modulate = Color(1,1,0,1)
    else:
        modulate = Color(1,1,1,1)
