extends Control
class_name options_menu

@onready var mas_lab = $CenterContainer/VBoxContainer/GridContainer/mas_per
@onready var mus_lab = $CenterContainer/VBoxContainer/GridContainer/mus_per
@onready var sfx_lab = $CenterContainer/VBoxContainer/GridContainer/sfx_per

func _on_mas_slider_value_changed(value: float) -> void:
    Sound.set_vol(Sound.BUS.MASTER, value)
    mas_lab.text = str(int(value * 100)) + "%"

func _on_mus_slider_value_changed(value: float) -> void:
    Sound.set_vol(Sound.BUS.MUSIC, value)
    mus_lab.text = str(int(value * 100)) + "%"

func _on_sfx_slider_value_changed(value: float) -> void:
    Sound.set_vol(Sound.BUS.SFX, value)
    sfx_lab.text = str(int(value * 100)) + "%"

func _on_return_pressed() -> void:
    self.set_visible(false)
