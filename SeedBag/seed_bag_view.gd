class_name SeedBagView extends Control
## [SeedBagView] is the view component of the seed bag. It creates a grid of
## [SeedBagButtons] and handles visibility based on the [signal ToolMenu.tool_selected]
## signal. Has a transient setter for the seed bag, which passes the reference to a
## [SeedBag] object to each [SeedBagButton].

## packed button scene for crops in the seed bag.
const packed_seed_button: PackedScene = preload("res://SeedBag/seed_bag_button.tscn")

## The number of elements in [enum Crop.crop] excluding [constant Crop.crop.NONE].
var n_crops = Crop.crop.size()-1 # -1 because we don't include Crop.crop.NONE


## Initializes the seed bag with a button for each crop
func _ready() -> void:
    var crop_keys = Crop.crop.keys()
    for i in range(n_crops):
        %SeedGrid.add_child(packed_seed_button.instantiate())
        %SeedGrid.get_child(i).set_crop(Crop.crop.get(crop_keys[i+1])) # +1 to index 1-10 instead of 0-9


## Responds to [signal ToolMenu.tool_selected] so the seed bag only appears if the shovel is selected.
func _tool_selected(tool: int) -> void:
    visible = tool == 0


## Setter for the [SeedBag] reference in the [SeedBagView].
## param [param sb]: The [SeedBag] object that this view displays.
## Passes the [SeedBag] reference on to each [SeedBagButton].
func set_seed_bag(sb: SeedBag) -> void:
    for i in range(n_crops):
        %SeedGrid.get_child(i).set_seed_bag(sb)
