extends Node

## selected crop
enum sc {NONE, CORN, POTATO, WHEAT}
var selected_crop = sc.CORN

func set_selected_crop(crop: sc) -> void:
    selected_crop = crop

func get_selected_crop() -> sc:
    return selected_crop
