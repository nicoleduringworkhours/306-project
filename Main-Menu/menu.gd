extends Control

@onready var options_menu = preload("res://Options/options.tscn")
var options_instance = null #keeps track of whether an options menu instance has been created

func _ready():
    #initial focus
    $VBoxContainer/StartButton.grab_focus()

func _on_start_button_pressed() -> void:
    get_tree().change_scene_to_file("res://FarmPlot/farm_plot.tscn")


func _on_quit_button_pressed() -> void:
    get_tree().quit()


func _on_options_button_pressed() -> void:
    if options_instance == null :
        #create menu instance
        options_instance = options_menu.instantiate() 
        add_child(options_instance)
        
        #connect to the close signal and calls _on_options_closed() when it emits signal
        options_instance.close_options.connect(_on_options_closed)
        
        #hide main and show options
        hide_main_menu()
        options_instance.show()
    
func _on_options_closed():
    #show main menu buttons again
    show_main_menu()
    if options_instance:
        #hide options menu
        options_instance.hide()

func hide_main_menu():
    #hide main menu buttons
    $VBoxContainer.hide()

func show_main_menu():
    #show main menu
    $VBoxContainer.show()
    
