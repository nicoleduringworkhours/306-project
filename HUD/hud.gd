extends Node

func get_money(amount: int):
    var money_label = $Label
    money_label.add_money(amount)
