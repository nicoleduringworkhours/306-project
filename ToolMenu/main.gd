extends Node

@onready var tile_map_layer = $TileMapLayer
@onready var tool_menu = $ToolMenu

var current_tool: String = "shovel"
var cursor_icons := {
    "hoe": preload("res://Assets/Icons/tool_hoe.png"),
    "watering_can": preload("res://Assets/Icons/tool_watering_can.png"),
    "shovel": preload("res://Assets/Icons/tool_shovel.png"),
}

func _ready():
    tool_menu.connect("tool_selected", Callable(self, "_on_tool_selected"))

func _on_tool_selected(tool_name: String):
    current_tool = tool_name
    print("Selected tool:", tool_name)
    _update_cursor()

func _update_cursor():
    if current_tool == "":
        Input.set_custom_mouse_cursor(null)
    else:
        if current_tool in cursor_icons:
            Input.set_custom_mouse_cursor(cursor_icons[current_tool], Input.CURSOR_ARROW)
