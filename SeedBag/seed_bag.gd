extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    %GridSquare.set_crop(GameManager.sc.CORN)
    %GridSquare2.set_crop(GameManager.sc.POTATO)
    %GridSquare3.set_crop(GameManager.sc.WHEAT)

    %GridSquare.modulate_button.connect(_modulate_button)
    %GridSquare2.modulate_button.connect(_modulate_button)
    %GridSquare3.modulate_button.connect(_modulate_button)
    %GridSquare4.modulate_button.connect(_modulate_button)
    %GridSquare5.modulate_button.connect(_modulate_button)
    %GridSquare6.modulate_button.connect(_modulate_button)
    %GridSquare7.modulate_button.connect(_modulate_button)
    %GridSquare8.modulate_button.connect(_modulate_button)
    %GridSquare9.modulate_button.connect(_modulate_button)
    %GridSquare4.disabled = true
    %GridSquare5.disabled = true
    %GridSquare6.disabled = true
    %GridSquare7.disabled = true
    %GridSquare8.disabled = true
    %GridSquare9.disabled = true


func _tool_selected(tool_name: String) -> void: 
    if tool_name == "shovel":
        visible = true
    else:
        visible = false

func _modulate_button() -> void:
    %GridSquare.modulate = Color(1, 1, 1, 1)
    %GridSquare2.modulate = Color(1, 1, 1, 1)
    %GridSquare3.modulate = Color(1, 1, 1, 1)
    %GridSquare4.modulate = Color(1, 1, 1, 1)
    %GridSquare5.modulate = Color(1, 1, 1, 1)
    %GridSquare6.modulate = Color(1, 1, 1, 1)
    %GridSquare7.modulate = Color(1, 1, 1, 1)
    %GridSquare8.modulate = Color(1, 1, 1, 1)
    %GridSquare9.modulate = Color(1, 1, 1, 1)
