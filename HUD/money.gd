extends Label

var money: int = 0
const text_pref: String = "MONEY: "

func set_money(m: int) -> void:
    money = m
    text = text_pref + str(money)

func add_money(m: int) -> void:
    money += m
    text = text_pref + str(money)
