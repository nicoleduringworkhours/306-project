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

# FIX: not balanced
const crop_val: Dictionary[crop, int] = {
    crop.NONE: 0,
    crop.BEAN: 1,
    crop.TOMATO: 2,
    crop.EGGPLANT: 4,
    crop.PINEAPPLE: 5,
    crop.WHEAT: 10,
    crop.STRAWBERRY: 10,
    crop.POTATO: 11,
    crop.ORANGE: 3,
    crop.CORN: 8,
}

const crop_cost: Dictionary[crop, int] = {
    crop.NONE: 0,
    crop.BEAN: 1,
    crop.TOMATO: 2,
    crop.EGGPLANT: 4,
    crop.PINEAPPLE: 5,
    crop.WHEAT: 2,
    crop.STRAWBERRY: 10,
    crop.POTATO: 5,
    crop.ORANGE: 3,
    crop.CORN: 6,
}

# FIX: not balanced
const crop_unlock_cost: Dictionary[crop, int] = {
    crop.NONE: 0,
    crop.BEAN: 0,
    crop.TOMATO: 1,
    crop.EGGPLANT: 1,
    crop.PINEAPPLE: 2,
    crop.WHEAT: 3,
    crop.STRAWBERRY: 5,
    crop.POTATO: 8,
    crop.ORANGE: 13,
    crop.CORN: 21,
}

const crop_texture: Dictionary[crop, Resource] = {
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
