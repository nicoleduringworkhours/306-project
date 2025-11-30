class_name BagButton extends Button

var button_crop: Crop.crop = Crop.crop.NONE
var crop_sprite_lut = {
    1: "res://Assets/SeedBag/bean.png",
    2: "res://Assets/SeedBag/tomato.png",
    3: "res://Assets/SeedBag/eggplant.png",
    4: "res://Assets/SeedBag/pineapple.png",
    5: "res://Assets/SeedBag/wheat.png",
    6: "res://Assets/SeedBag/strawberry.png",
    7: "res://Assets/SeedBag/potato.png",
    8: "res://Assets/SeedBag/orange.png",
    9: "res://Assets/SeedBag/corn.png",
}

signal modulate_button(button: BagButton)

func _on_pressed() -> void:
    Sound.play_sfx(Sound.EFFECT.UI_CLICK)
    modulate_button.emit(self)

func set_crop(crop: Crop.crop) -> void:
    disabled = crop == Crop.crop.NONE
    modulate = Color(1,1,1,1)
    button_crop = crop
    if not disabled:
        var image = Image.load_from_file(crop_sprite_lut[crop])
        var texture = ImageTexture.create_from_image(image)
        icon = texture
