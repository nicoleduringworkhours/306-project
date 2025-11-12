extends Control

var prev_button: BagButton

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

    _modulate_button(%GridSquare)

func _tool_selected(t: int) -> void:
    visible = t == 0

func _modulate_button(button: BagButton) -> void:
    if prev_button:
        prev_button.modulate = Color(1,1,1,1)
    button.modulate = Color(1,1,0,1)
    prev_button = button
