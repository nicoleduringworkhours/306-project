extends Button
class_name BagButton

var button_crop: SeedBag.crop = SeedBag.crop.NONE

signal modulate_button(button: BagButton)

func _on_pressed() -> void:
    Sound.play_sfx(Sound.EFFECT.UI_CLICK)
    #GameManager.set_selected_crop(button_crop)
    modulate_button.emit(self)

func set_crop(crop: SeedBag.crop) -> void:
    disabled = crop == SeedBag.crop.NONE
    modulate = Color(1,1,1,1)
    button_crop = crop
