extends Label

var money: int

func set_money(m: int) -> void:
    money = m
    text = "MONEY : %d" % money

func add_money(m: int) -> void:
    set_money(money + m)


func _ready() -> void:
    set_money(0)
