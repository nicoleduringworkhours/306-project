extends Control
class_name Pause

@onready var menu: CenterContainer = $Menu ## the pause menu
@onready var opts: Control = $Options ## the options menu

## intialization. connect the options close function for this menu
func _ready() -> void:
    opts.close_options.connect(_options_closed)

## handle input
func _input(event) -> void:
    # when the pause action is pressed, pause (if the options menu is
    # not open)
    if event.is_action_pressed("pause") and not opts.is_visible():
        _pause()

## pause/unpause the game, open/close the pause menu
func _pause() -> void:
    Sound.play_sfx(Sound.EFFECT.MENU)
    get_tree().paused = not get_tree().paused
    menu.visible = not menu.visible

## Handle options menu press, hide the pause menu, bring up the
## options menu
func _on_options_pressed() -> void:
    Sound.play_sfx(Sound.EFFECT.MENU)
    opts.load_opts() ## refresh sliders so they're correct
    menu.set_visible(false)
    opts.set_visible(true)

## handle options close button, bring back the pause menu
func _options_closed() -> void:
    Sound.play_sfx(Sound.EFFECT.MENU)
    menu.set_visible(true)

## handle quit button press. close the game
func _on_quit_pressed() -> void:
    Sound.play_sfx(Sound.EFFECT.UI_CLICK)
    get_tree().quit()

## handle return to title press. switch scene to title.
func _on_to_title_pressed() -> void:
    Sound.play_sfx(Sound.EFFECT.UI_CLICK)
    get_tree().paused = false
    get_tree().change_scene_to_file("res://MainMenu/Menu.tscn")
