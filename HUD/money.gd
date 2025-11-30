extends Label

var money: int = 50
const text_pref: String = "MONEY: "

func set_money(m: int) -> void:
    Money.money = m
    text = text_pref + str(Money.money)

func add_money(m: int) -> void:
    Money.money += m
    text = text_pref + str(Money.money)
