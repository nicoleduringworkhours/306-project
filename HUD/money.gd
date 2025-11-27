extends Label

var money: int = 50
const text_pref: String = "MONEY: "

func _ready() -> void:
    text = text_pref + str(money)
    
func set_money(m: int) -> void:
    money = m
    text = text_pref + str(money)

func add_money(m: int) -> void:
    if money - m <= 0:
        return
    money += m
    text = text_pref + str(money)
    
func get_money()->int:
    return money
