extends Control

func _ready():
    $VBoxContainer/StartButton.grab_focus()

func _on_start_button_pressed() -> void:
<<<<<<< HEAD
    get_tree().change_scene_to_file("res://FarmPlot/farm_plot.tscn")
=======
    get_tree().change_scene_to_file("res://farm_plot.tscn")
>>>>>>> 0c4462117fee72c97e40190957530d45a08dc2f3


func _on_quit_button_pressed() -> void:
    get_tree().quit()


func _on_options_button_pressed() -> void:
    pass # Replace with function body.
