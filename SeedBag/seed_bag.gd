extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    var i: Item = Item.new()
    var img: Texture2D = load("res://icon.svg")
    i.set_texture(img)
    %GridSquare.set_item(i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
