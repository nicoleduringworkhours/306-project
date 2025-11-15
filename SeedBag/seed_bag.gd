extends Control
class_name SeedBag

var prev_button: BagButton

enum crop {NONE=0, CORN=9, WHEAT=5, POTATO=7}
var current_crop: crop = crop.CORN

func _ready() -> void:
    %GridSquare.set_crop(crop.CORN)
    %GridSquare2.set_crop(crop.POTATO)
    %GridSquare3.set_crop(crop.WHEAT)

    %GridSquare.modulate_button.connect(_modulate_button)
    %GridSquare2.modulate_button.connect(_modulate_button)
    %GridSquare3.modulate_button.connect(_modulate_button)
    %GridSquare4.modulate_button.connect(_modulate_button)
    %GridSquare5.modulate_button.connect(_modulate_button)
    %GridSquare6.modulate_button.connect(_modulate_button)
    %GridSquare7.modulate_button.connect(_modulate_button)
    %GridSquare8.modulate_button.connect(_modulate_button)
    %GridSquare9.modulate_button.connect(_modulate_button)

    _modulate_button(%GridSquare)

func _tool_selected(t: int) -> void:
    visible = t == 0

func _modulate_button(button: BagButton) -> void:
    if prev_button:
        prev_button.modulate = Color(1,1,1,1)
    button.modulate = Color(1,1,0,1)
    prev_button = button
    current_crop = button.button_crop

func get_crop() -> crop:
    return current_crop
