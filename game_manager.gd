extends Node

## selected crop
enum sc {NONE, CORN, POTATO, WHEAT}
var selected_crop = sc.NONE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass


func set_selected_crop(crop: sc) -> void:
    selected_crop = crop

func get_selected_crop() -> sc:
    return selected_crop
