extends Control

@onready var opts = $Options
@onready var vb = $VBoxContainer

func _ready():
    #initial focus
    $VBoxContainer/StartButton.grab_focus()
    opts.close_options.connect(option_toggle)

func _on_start_button_pressed() -> void:
    get_tree().change_scene_to_file("res://GameScene.tscn")

func _on_quit_button_pressed() -> void:
    get_tree().quit()

func option_toggle() -> void:
    vb.set_visible(not vb.visible)
    opts.set_visible(not opts.visible)

