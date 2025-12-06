extends Node2D
class_name FarmPlotTAT
## A farm plot with a ground grid, and a grid of planted/growing crops

## change the amount of money the player has by [param val]
signal money_change(val: int)

const rows = 12
const cols = 15

var _p: PlotMap ## [member _p] the ground grid
var _c: CropMap ## [member _c] the crop grid

## initialize children, a crop map and a plot map
func _ready() -> void:
    _p = load("res://FarmPlot/Plot/plot.tscn").instantiate().data(rows, cols)
    _c = load("res://FarmPlot/Crop/crop.tscn").instantiate().data(rows, cols, _p)

    add_child(_p)
    add_child(_c)

    _c.money_change.connect(money_change.emit)
    _p.got_watered.connect(_c.got_watered)

## publish api from children without exposing them
func set_money_ref(money_func: Callable):
    _c.set_money_ref(money_func)

## handle hoe press at location [param loc]
func hoe_press(loc: Vector2):
    _p.hoe_press(to_local(loc))
    _c.hoe_press(to_local(loc))

## handle shovel press at location [param loc]
func shovel_press(loc: Vector2, s: Crop.crop):
    _c.shovel_press(to_local(loc), s)

## handle watering can press at location [param loc]
func water_press(loc: Vector2):
    _p.water_press(to_local(loc))

## handle fertilizer press at location [param loc]
func fertilizer_press(loc: Vector2):
    _c.fertilizer_press(to_local(loc))
