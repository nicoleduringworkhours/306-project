class_name SeedBag extends Control

var prev_button: BagButton
var packed_gridsquare: PackedScene = preload("res://SeedBag/grid_square.tscn")

var current_crop: Crop.crop = Crop.crop.CORN

func _ready() -> void:
    var crops = Crop.crop.keys()
    var n_crops = Crop.crop.size()
    for i in range(n_crops-1):
        %SeedGrid.add_child(packed_gridsquare.instantiate())
        %SeedGrid.get_child(i).set_crop(Crop.crop[crops[i+1]])
        %SeedGrid.get_child(i).modulate_button.connect(_modulate_button)
    _modulate_button(%SeedGrid.get_child(0))

func _tool_selected(t: int) -> void:
    visible = t == 0

func _modulate_button(button: BagButton) -> void:
    if prev_button:
        prev_button.modulate = Color(1,1,1,1)
    button.modulate = Color(1,1,0,1)
    prev_button = button
    current_crop = button.button_crop

func get_crop() -> Crop.crop:
    return current_crop

    
