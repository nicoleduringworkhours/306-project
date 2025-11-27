extends Node2D
class_name FarmPlotTAT

signal get_money(val: int)
signal reduce_money (val : int)

const rows = 12
const cols = 15

var _p: PlotMap
var _c: CropMap

var cost_of_crop = 0

func _ready() -> void:
    _p = load("res://FarmPlot/Plot/plot.tscn").instantiate().data(rows, cols)
    _c = load("res://FarmPlot/Crop/crop.tscn").instantiate().data(rows, cols, _p)

    add_child(_p)
    add_child(_c)

    _c.harvested.connect(get_money.emit)
    _c.seed_planted.connect(seed_planted)
    _p.got_watered.connect(_c.got_watered)

func hoe_press(loc: Vector2):
    _p.hoe_press(to_local(loc))
    _c.hoe_press(to_local(loc))

func shovel_press(loc: Vector2, s: Crop.crop):
    _c.shovel_press(to_local(loc), s)

func water_press(loc: Vector2):
    _p.water_press(to_local(loc))

func want_to_plant(crop_type: Crop.crop) -> bool:
    match crop_type:
         Crop.crop.CORN: 
            cost_of_crop = 3
            if Money.money - cost_of_crop <= 0:
                return false
         Crop.crop.WHEAT:
             cost_of_crop = 2
             if Money.money - cost_of_crop <= 0:
                return false
         Crop.crop.POTATO:
            cost_of_crop = 5
            if Money.money - cost_of_crop <= 0:
                return false
    return true

## Emits a signal to get_money to deduct the total amount of money based on the 
## crop type.

## Parameters:
## - crop_type: the kind of crop planted
 
func seed_planted(crop_type : Crop.crop):
    match crop_type:
         Crop.crop.CORN: 
            reduce_money.emit(-3) #deduct 3 from total money if corn is planted
         Crop.crop.WHEAT:
            reduce_money.emit(-2) #deduct 2 from total money if wheat is planted
         Crop.crop.POTATO:
            reduce_money.emit(-5) #deduct 5 from total money if potato is planted
        
        
