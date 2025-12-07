class_name Crop

enum crop {
    NONE,
    BEAN,
    TOMATO,
    EGGPLANT,
    PINEAPPLE,
    WHEAT,
    STRAWBERRY,
    POTATO,
    ORANGE,
    CORN,
}

const crop_val: Dictionary[crop, int] = {
    crop.NONE: 0,
    crop.BEAN: 3,
    crop.TOMATO: 28,
    crop.EGGPLANT: 40,
    crop.PINEAPPLE: 200,
    crop.WHEAT: 21,
    crop.STRAWBERRY: 50,
    crop.POTATO: 5,
    crop.ORANGE: 100,
    crop.CORN: 12,
}

const crop_cost: Dictionary[crop, int] = {
    crop.NONE: 0,
    crop.BEAN: 1,
    crop.TOMATO: 17,
    crop.EGGPLANT: 25,
    crop.PINEAPPLE: 100,
    crop.WHEAT: 13,
    crop.STRAWBERRY: 30,
    crop.POTATO: 2,
    crop.ORANGE: 60,
    crop.CORN: 5,
}

const crop_unlock_cost: Dictionary[crop, int] = {
    crop.NONE: 0,
    crop.BEAN: 0,
    crop.TOMATO: 100,
    crop.EGGPLANT: 150,
    crop.PINEAPPLE: 600,
    crop.WHEAT: 50,
    crop.STRAWBERRY: 200,
    crop.POTATO: 8,
    crop.ORANGE: 400,
    crop.CORN: 15,
}

const crop_texture: Dictionary[crop, Resource] = {
    crop.NONE: preload("res://Assets/SeedBag/lock.png"),
    crop.BEAN: preload("res://Assets/SeedBag/bean.png"),
    crop.TOMATO: preload("res://Assets/SeedBag/tomato.png"),
    crop.EGGPLANT: preload("res://Assets/SeedBag/eggplant.png"),
    crop.PINEAPPLE: preload("res://Assets/SeedBag/pineapple.png"),
    crop.WHEAT: preload("res://Assets/SeedBag/wheat.png"),
    crop.STRAWBERRY: preload("res://Assets/SeedBag/strawberry.png"),
    crop.POTATO: preload("res://Assets/SeedBag/potato.png"),
    crop.ORANGE: preload("res://Assets/SeedBag/orange.png"),
    crop.CORN: preload("res://Assets/SeedBag/corn.png"),
}
