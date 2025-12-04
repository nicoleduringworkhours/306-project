extends Node
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
