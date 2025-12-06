extends Control
class_name options_menu

signal close_options() ## emitted when options is closed

## the sliders and labels for the master, music, and sfx volumes
@onready var mas_lab = $CenterContainer/VBoxContainer/GridContainer/mas_per
@onready var mus_lab = $CenterContainer/VBoxContainer/GridContainer/mus_per
@onready var sfx_lab = $CenterContainer/VBoxContainer/GridContainer/sfx_per
@onready var mas_slider = $CenterContainer/VBoxContainer/GridContainer/mas_slider
@onready var mus_slider = $CenterContainer/VBoxContainer/GridContainer/mus_slider
@onready var sfx_slider = $CenterContainer/VBoxContainer/GridContainer/sfx_slider

## initialize the menu
func _ready() -> void:
    load_opts()

## reload the volume sliders/values with the current values
func load_opts() -> void:
    # master bus
    var v: float = Sound.get_vol(Sound.BUS.MASTER)
    mas_lab.text = str(int(v* 100)) + "%"
    mas_slider.value = v
    # music bus
    v = Sound.get_vol(Sound.BUS.MUSIC)
    mus_lab.text = str(int(v* 100)) + "%"
    mus_slider.value = v
    # sfx bus
    v = Sound.get_vol(Sound.BUS.SFX)
    sfx_lab.text = str(int(v* 100)) + "%"
    sfx_slider.value = v

## handle the volume change for the master slider to volume [param value]
## update the label and change the volume of the master bus
func _on_mas_slider_value_changed(value: float) -> void:
    Sound.set_vol(Sound.BUS.MASTER, value)
    mas_lab.text = str(int(value * 100)) + "%"

## handle the volume change for the music slider to volume [param value]
## update the label and change the volume of the music bus
func _on_mus_slider_value_changed(value: float) -> void:
    Sound.set_vol(Sound.BUS.MUSIC, value)
    mus_lab.text = str(int(value * 100)) + "%"

## handle the volume change for the sfx slider to volume [param value]
## update the label and change the volume of the sfx bus
func _on_sfx_slider_value_changed(value: float) -> void:
    Sound.set_vol(Sound.BUS.SFX, value)
    sfx_lab.text = str(int(value * 100)) + "%"

## handle the return button press to close the options
func _on_return_pressed() -> void:
    Sound.play_sfx(Sound.EFFECT.MENU)
    close_options.emit()
    set_visible(false)
