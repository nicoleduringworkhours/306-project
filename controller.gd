extends Node2D

var tlm
@onready var sb: SeedBag = $SeedBag

signal water(earl: Vector2)
signal hoe(earl: Vector2)
signal shovel(earl: Vector2, bert: SeedBag.crop)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    tlm = $ToolMenu
    tlm.tool_selected.connect(sb._tool_selected)

    var tm = $farmplot
    water.connect(tm.water_press)
    hoe.connect(tm.hoe_press)
    shovel.connect(tm.growth.shovel_press)
    shovel.connect(tm.shovel_press)

    var hud = $Hud
    tm.tm.get_money.connect(hud.add_money)

func _unhandled_input(event) -> void:
    if event.is_action_pressed("click"):
        match tlm.get_selected_tool():
            tlm.tools.SHOVEL:
                shovel.emit(event.position, sb.get_crop())
            tlm.tools.HOE:
                hoe.emit(event.position)
            tlm.tools.WATERING_CAN:
                water.emit(event.position)
