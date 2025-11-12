extends Node2D

var tlm

signal water(earl: Vector2)
signal hoe(earl: Vector2)
signal shovel(earl: Vector2, bert: GameManager.sc)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    tlm = $"ToolMenu/Tool container"
    var sb = $SeedBag
    tlm.tool_selected.connect(sb._tool_selected)

    var tm = $farmplot
    water.connect(tm.water_press)
    hoe.connect(tm.hoe_press)
    shovel.connect(tm.growth.shovel_press)
    shovel.connect(tm.shovel_press)
    
    var hud = $Hud
    tm.tm.get_money.connect(hud.get_money)

func _unhandled_input(event) -> void:
    if event.is_action_pressed("click"):
        match tlm.get_selected_tool():
            "shovel":
                shovel.emit(event.position, GameManager.get_selected_crop())
            "hoe":
                hoe.emit(event.position)
            "watering_can":
                water.emit(event.position)
