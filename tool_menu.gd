extends Control

signal tool_selected(tool_name)

var selected_button: TextureButton = null

func _on_tool_pressed(tool_name: String, button: TextureButton):
    if selected_button:
        selected_button.modulate = Color(1, 1, 1)
    selected_button = button
    selected_button.modulate = Color(1, 1, 0)

    var tool_icon = button.texture_normal
    if tool_icon:
        Input.set_custom_mouse_cursor(tool_icon)
    else:
        Input.set_custom_mouse_cursor(null)

    emit_signal("tool_selected", tool_name)

func _on_tool_hoe_pressed() -> void:
    _on_tool_pressed("hoe", $"Toolbox container/ToolHoe")

func _on_tool_watering_can_pressed() -> void:
    _on_tool_pressed("watering_can", $"Toolbox container/ToolWateringCan")

func _on_tool_shovel_pressed() -> void:
    _on_tool_pressed("shovel", $"Toolbox container/ToolShovel")
