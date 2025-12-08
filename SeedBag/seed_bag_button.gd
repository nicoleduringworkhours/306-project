class_name SeedBagButton extends Button

## The [enum Crop.crop] that this button represents.
var crop: Crop.crop = Crop.crop.NONE
## A reference to the [SeedBag] model that this button is associated with.
var seed_bag: SeedBag


## Signal handler for [signal SeedBag.seed_bag_updated] That updates the visual
## representation of the crop's selected and locked state.
func _on_seed_bag_updated() -> void:
    if seed_bag.seed_unlocked[crop]:
        set_button_icon(Crop.crop_texture[crop])
        set_text("$"+str(Crop.crop_cost[crop]))
        _modulate_button(seed_bag.get_seed_state(crop))
    else:
        set_button_icon(Crop.crop_texture[Crop.crop.NONE])
        set_text("$"+str(Crop.crop_unlock_cost[crop]))
        _modulate_button(seed_bag.get_seed_state(crop))


## param [param c]: The [enum Crop.crop] for this [SeedBagButton] to represent.
## Sets [member SeedBagButton.crop] as well as the icon and price/unlock price text
## for this button.
func set_crop(c: Crop.crop) -> void:
    crop = c
    set_button_icon(Crop.crop_texture[Crop.crop.NONE])
    set_text("$"+str(Crop.crop_unlock_cost[crop]))


## param [param sb]: The [SeedBag] reference to associate this button with.
## Sets [member SeedBagButton.seed_bag] to [param sb]. Connects [signal SeedBag.seed_bag_updated]
## to the handler [method SeedBagButton._on_seed_bag_updated].
func set_seed_bag(sb: SeedBag) -> void:
    seed_bag = sb
    seed_bag.seed_bag_updated.connect(_on_seed_bag_updated)


## param [param selected]: [code]true[/code] if this button is "selected" in the model.
## [code]false[/code] otherwise.
## Helper function to visually modulate the button based on whether it is selected or not.
func _modulate_button(selected: bool) -> void:
    if selected:
        modulate = Color(1,1,0,1)
    else:
        modulate = Color(1,1,1,1)
