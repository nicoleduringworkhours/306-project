class_name pause
extends Node2D

var menu: CenterContainer

func _ready() -> void:
    menu = $Menu
    menu.visible = false

func _input(event) -> void:
    if event.is_action_pressed("pause"):
        _pause()

func _pause() -> void:
        get_tree().paused = not get_tree().paused
        menu.visible = not menu.visible

func _on_resume_pressed() -> void:
    _pause()

func _on_options_pressed() -> void:
    print("TODO: options")

func _on_quit_pressed() -> void:
    get_tree().quit()
