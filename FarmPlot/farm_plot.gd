extends Node2D
class_name FarmPlotTAT

signal get_money(val: int)

const rows = 12
const cols = 15

var _p: PlotMap
var _c: CropMap

func _ready() -> void:
    _p = load("res://FarmPlot/Plot/plot.tscn").instantiate().data(rows, cols)
    _c = load("res://FarmPlot/Crop/crop.tscn").instantiate().data(rows, cols, _p)

    add_child(_p)
    add_child(_c)

    _c.harvested.connect(get_money.emit)
    _p.got_watered.connect(_c.got_watered)

func hoe_press(loc: Vector2):
    _p.hoe_press(to_local(loc))
    _c.hoe_press(to_local(loc))

func shovel_press(loc: Vector2, s: SeedBag.crop):
    _c.shovel_press(to_local(loc), s)

func water_press(loc: Vector2):
    _p.water_press(to_local(loc))
