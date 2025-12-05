extends Node2D

@onready var tlm = $ToolMenu
@onready var sb: SeedBag = $SeedBag
@onready var hud: Money = $Hud

signal water(earl: Vector2)
signal hoe(earl: Vector2)
signal shovel(earl: Vector2, bert: Crop.crop)
signal fertilizer(earl: Vector2)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    tlm.tool_selected.connect(sb._tool_selected)

    var farm_plot = $farmplot
    water.connect(farm_plot.water_press)
    hoe.connect(farm_plot.hoe_press)
    shovel.connect(farm_plot.shovel_press)
    fertilizer.connect(farm_plot.fertilizer_press) 

    farm_plot.set_money_ref(hud.get_money)
    farm_plot.money_change.connect(hud.add_money)

    tlm.money_change.connect(hud.add_money)
    tlm.set_money_ref(hud.get_money)

func _unhandled_input(event) -> void:
    if event.is_action_pressed("click"):
        match tlm.get_selected_tool():
            ToolModel.tools.SHOVEL:
                shovel.emit(event.position, sb.get_crop())
            ToolModel.tools.HOE:
                hoe.emit(event.position)
            ToolModel.tools.WATERING_CAN:
                water.emit(event.position)
            ToolModel.tools.FERTILIZER:
                if tlm.fertilizer_unlocked():
                    fertilizer.emit(event.position)
