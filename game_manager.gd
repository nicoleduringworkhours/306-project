extends Node

enum {SC_NONE, SC_CORN, SC_POTATO, SC_WHEAT}
var selected_crop = SC_NONE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass


func set_selected_crop(crop: int) -> void:
    selected_crop = crop

func get_selected_crop() -> int:
    return selected_crop
