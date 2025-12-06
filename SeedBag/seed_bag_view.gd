class_name SeedBagView extends Control

const packed_seed_button: PackedScene = preload("res://SeedBag/seed_bag_button.tscn")
var n_crops = Crop.crop.size()-1 # -1 because we don't include Crop.crop.NONE

func _ready() -> void:
    var crop_keys = Crop.crop.keys()
    for i in range(n_crops):
        %SeedGrid.add_child(packed_seed_button.instantiate())
        %SeedGrid.get_child(i).set_crop(Crop.crop.get(crop_keys[i+1])) # +1 to index 1-10 instead of 0-9

func _tool_selected(tool: int) -> void:
    visible = tool == 0

func set_seed_bag(sb: SeedBag) -> void:
    for i in range(n_crops):
        %SeedGrid.get_child(i).set_seed_bag(sb)
