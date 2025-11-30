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
    crop.CORN: 8,
    crop.WHEAT: 10,
    crop.POTATO: 11,
}
