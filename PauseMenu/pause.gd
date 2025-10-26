class_name pause
extends Node2D

var menu: CenterContainer
var opts

func _ready() -> void:
    opts = preload("res://Options/options.tscn").instantiate()
    menu = $Menu
    menu.visible = false

    add_child(opts)
    opts.set_visible(false)
    opts.close_options.connect(_options_closed)

func _input(event) -> void:
    if event.is_action_pressed("pause"):
        _pause()

func _pause() -> void:
        get_tree().paused = not get_tree().paused
        menu.visible = not menu.visible

func _on_resume_pressed() -> void:
    _pause()

func _on_options_pressed() -> void:
    menu.set_visible(false)
    opts.set_visible(true)

    print("TODO: options")

func _options_closed() -> void:
    menu.set_visible(true)

func _on_quit_pressed() -> void:
    get_tree().quit()
