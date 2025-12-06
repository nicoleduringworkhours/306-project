extends Label
class_name Money

## The amount of money the player has
@export var money: int = 50

## the string prefix
const text_pref: String = "MONEY: "

## initialize the text label
func _ready() -> void:
    text = text_pref + str(money)

## set the money the player has to [param m]
## and update the label
func set_money(m: int) -> void:
    money = m
    text = text_pref + str(money)

## add [param m] to the money the player has
## and update the label
func add_money(m: int) -> void:
    money += m
    text = text_pref + str(money)

## get the money the player has
func get_money() -> int:
    return money
