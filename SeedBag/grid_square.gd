class_name BagButton extends Button

var button_crop: Crop.crop = Crop.crop.NONE
var crop_sprite_lut = {
    Crop.crop.BEAN: "res://Assets/SeedBag/potato.png",
    Crop.crop.TOMATO: "res://Assets/SeedBag/tomato.png",
    Crop.crop.EGGPLANT: "res://Assets/SeedBag/eggplant.png",
    Crop.crop.PINEAPPLE: "res://Assets/SeedBag/pineapple.png",
    Crop.crop.WHEAT: "res://Assets/SeedBag/wheat.png",
    Crop.crop.STRAWBERRY: "res://Assets/SeedBag/strawberry.png",
    Crop.crop.POTATO: "res://Assets/SeedBag/potato.png",
    Crop.crop.ORANGE: "res://Assets/SeedBag/orange.png",
    Crop.crop.CORN: "res://Assets/SeedBag/corn.png",
}

signal modulate_button(button: BagButton)

func _on_pressed() -> void:
    Sound.play_sfx(Sound.EFFECT.UI_CLICK)
    modulate_button.emit(self)

func set_crop(crop: Crop.crop) -> void:
    disabled = crop == Crop.crop.NONE
    modulate = Color(1,1,1,1)
    button_crop = crop
    var image = Image.load_from_file(crop_sprite_lut[crop])
    var texture = ImageTexture.create_from_image(image)
    icon = texture
