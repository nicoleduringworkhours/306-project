extends Button

var button_crop = GameManager.SC_NONE

func _ready() -> void:
    pass # TODO

func _on_pressed() -> void:
    GameManager.set_selected_crop(button_crop)

func set_crop(crop) -> void:
    button_crop = crop
