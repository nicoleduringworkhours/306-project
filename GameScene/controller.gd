extends Node2D

var tlm
@onready var sb: SeedBag = $SeedBag
@onready var hud: Money = $Hud

signal water(earl: Vector2)
signal hoe(earl: Vector2)
signal shovel(earl: Vector2, bert: Crop.crop)
signal fertilizer(earl: Vector2, bert: Crop.crop)
# Fertilizer unlock state
var fertilizer_unlocked: bool = false
var fertilizer_unlock_end_time: float = 0.0

const FERTILIZER_COST := 30
const FERTILIZER_DURATION := 120.0  # 3 minutes in seconds

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    tlm = $ToolMenu
    tlm.tool_selected.connect(sb._tool_selected)

    var farm_plot = $farmplot
    water.connect(farm_plot.water_press)
    hoe.connect(farm_plot.hoe_press)
    shovel.connect(farm_plot.shovel_press)
    fertilizer.connect(farm_plot.fertilizer_press) 

    var hud = $Hud
    farm_plot.set_money_ref(hud.get_money)
    farm_plot.money_change.connect(hud.add_money)

func _unhandled_input(event) -> void:
    if event.is_action_pressed("click"):
        match tlm.get_selected_tool():
            tlm.tools.SHOVEL:
                shovel.emit(event.position, sb.get_crop())
            tlm.tools.HOE:
                hoe.emit(event.position)
            tlm.tools.WATERING_CAN:
                water.emit(event.position)
            tlm.tools.FERTILIZER:                           
                #fertilizer.emit(event.position, sb.get_crop())
                _handle_fertilizer_click(event.position)
 
# current constraint added to fertilizer: only unlocks for 30 bucks and user can access it for 3 mins before its locked again               
func _handle_fertilizer_click(pos: Vector2) -> void:
    var now := Time.get_unix_time_from_system()

    # If never unlocked, or 3 minutes have passed, try to (re)unlock
    if (not fertilizer_unlocked) or (now >= fertilizer_unlock_end_time):
        var current_money := hud.get_money()
        if current_money < FERTILIZER_COST:
            print("Not enough money to unlock fertilizer (need 30).")
            return

        # pay 30 and start a 3 min window
        hud.add_money(-FERTILIZER_COST)
        fertilizer_unlocked = true
        fertilizer_unlock_end_time = now + FERTILIZER_DURATION
        print("Fertilizer unlocked for 3 minutes.")

    # At this point it’s unlocked and within the time window 
    fertilizer.emit(pos, sb.get_crop())
