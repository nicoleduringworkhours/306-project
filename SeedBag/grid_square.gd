extends Button

## Item: whatever data struct needs to be stored in a grid square. Item type is placeholder.
var item: Item = null

func _ready() -> void:
    pass # TODO

func _on_pressed() -> void:
    pass # TODO

func get_item() -> Item:
    return item

func set_item(i: Item) -> void:
    item = i
    %GridSquare.set_button_icon(i.get_texture())
