extends Control

@onready var options_menu = preload(res://Options/options.gd)
var options_instance = null

func _ready():
    $VBoxContainer/StartButton.grab_focus()

func _on_start_button_pressed() -> void:
    get_tree().change_scene_to_file("res://FarmPlot/farm_plot.tscn")


func _on_quit_button_pressed() -> void:
    get_tree().quit()


func _on_options_button_pressed() -> void:
    if options_instance == null :
        options_instance = options_menu.instantiate()
        add_child(options_instance)
        
        #connect to the close signal
        options_instance.close_options.connect(close_options)
        
        #hide main and show options
        hide_main_menu()
        options_instance.show()
    
    pass # Replace with function body.
