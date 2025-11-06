extends Control
class_name options_menu

signal close_options()

@onready var mas_lab = $CenterContainer/VBoxContainer/GridContainer/mas_per
@onready var mus_lab = $CenterContainer/VBoxContainer/GridContainer/mus_per
@onready var sfx_lab = $CenterContainer/VBoxContainer/GridContainer/sfx_per
@onready var mas_slider = $CenterContainer/VBoxContainer/GridContainer/mas_slider
@onready var mus_slider = $CenterContainer/VBoxContainer/GridContainer/mus_slider
@onready var sfx_slider = $CenterContainer/VBoxContainer/GridContainer/sfx_slider

func _ready() -> void:
    load_opts()

func load_opts() -> void:
    var v: float = Sound.get_vol(Sound.BUS.MASTER)
    mas_lab.text = str(int(v* 100)) + "%"
    mas_slider.value = v
    v = Sound.get_vol(Sound.BUS.MUSIC)
    mus_lab.text = str(int(v* 100)) + "%"
    mus_slider.value = v
    v = Sound.get_vol(Sound.BUS.SFX)
    sfx_lab.text = str(int(v* 100)) + "%"
    sfx_slider.value = v

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
    Sound.play_sfx(Sound.EFFECT.MENU)
    close_options.emit()
    self.set_visible(false)
