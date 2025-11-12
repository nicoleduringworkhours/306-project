class_name Item
var texture:Texture2D = null

#TODO: either delete or make gridsquare use these instead of static textures

func set_texture(t: Texture2D) -> void:
    texture=t

func get_texture() -> Texture2D:
    return texture
