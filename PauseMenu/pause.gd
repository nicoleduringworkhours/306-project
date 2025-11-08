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
    if event.is_action_pressed("pause") and not opts.is_visible():
        _pause()

func _pause() -> void:
    Sound.play_sfx(Sound.EFFECT.MENU)
    get_tree().paused = not get_tree().paused
    menu.visible = not menu.visible

func _on_resume_pressed() -> void:
    _pause()

func _on_options_pressed() -> void:
    Sound.play_sfx(Sound.EFFECT.MENU)
    opts.load_opts()
    menu.set_visible(false)
    opts.set_visible(true)

func _options_closed() -> void:
    Sound.play_sfx(Sound.EFFECT.MENU)
    menu.set_visible(true)

func _on_quit_pressed() -> void:
    Sound.play_sfx(Sound.EFFECT.UI_CLICK)
    get_tree().quit()

func _on_to_title_pressed() -> void:
    Sound.play_sfx(Sound.EFFECT.UI_CLICK)
    get_tree().paused = false
    get_tree().change_scene_to_file("res://Main-Menu/Menu.tscn")
