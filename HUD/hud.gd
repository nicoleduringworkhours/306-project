extends Node

func _ready():
    var tm = get_node("res://FarmPlot/tm_manager")
    tm.get_money.connect(_get_money)
    
    
func _get_money(amount: int):
    
    var money_label = get_node("res://FarmPlot/money")
    money_label.add_money(amount)
