extends Node
@onready var money = 0

func _ready():
    var tm = get_node("res://FarmPlot/tm_manager.gd")
    tm.get_money.connect(_get_money)
    
    
func _get_money(amount: int):
    money += amount
    
    var money_label = get_node("res://FarmPlot/money.gd")
    money_label.add_money(money)
