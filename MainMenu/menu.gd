extends Control

@onready var opts = $Options
@onready var vb = $VBoxContainer

## initialize the main menu
func _ready():
    #initial focus
    $VBoxContainer/StartButton.grab_focus()
    opts.close_options.connect(option_toggle)

## handle start button press to start the game
func _on_start_button_pressed() -> void:
    get_tree().change_scene_to_file("res://GameScene/GameScene.tscn")

## handle quit button press to end the game
func _on_quit_button_pressed() -> void:
    get_tree().quit()

## handle option button press, hide the main menu, bring up the option menu
func option_toggle() -> void:
    vb.set_visible(not vb.visible)
    opts.set_visible(not opts.visible)
