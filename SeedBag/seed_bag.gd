extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    %GridSquare.set_crop(GameManager.SC_CORN)
    %GridSquare2.set_crop(GameManager.SC_POTATO)
    %GridSquare3.set_crop(GameManager.SC_WHEAT)


