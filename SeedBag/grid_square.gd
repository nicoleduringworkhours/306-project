extends Button

var button_crop = GameManager.sc.NONE

func _ready() -> void:
    modulate = Color(1, 1, 1, 1)

signal modulate_button()

func _on_pressed() -> void:
    GameManager.set_selected_crop(button_crop)
    modulate_button.emit()
    modulate = Color(1, 1, 0, 1)

func set_crop(crop) -> void:
    button_crop = crop
