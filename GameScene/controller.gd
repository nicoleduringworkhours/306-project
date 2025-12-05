extends Node2D

var tlm
var seed_bag_view: SeedBagView
var seed_bag: SeedBag

signal water(earl: Vector2)
signal hoe(earl: Vector2)
signal shovel(earl: Vector2, bert: Crop.crop)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    tlm = $ToolMenu
    tlm.tool_selected.connect(seed_bag_view._tool_selected)

    var farm_plot = $farmplot
    water.connect(farm_plot.water_press)
    hoe.connect(farm_plot.hoe_press)
    shovel.connect(farm_plot.shovel_press)

    var hud = $Hud
    farm_plot.set_money_ref(hud.get_money)
    farm_plot.money_change.connect(hud.add_money)

    seed_bag_view = $SeedBagView
    seed_bag = SeedBag.new()

    seed_bag_view.set_seed_bag(seed_bag)
    seed_bag.set_money(hud)
    seed_bag.unlock_crop(Crop.crop.BEAN)
    seed_bag.set_crop(Crop.crop.BEAN)


    var n_crops = Crop.crop.size()-1 # -1 because we don't include Crop.crop.NONE
    for i in range(n_crops):
        %SeedGrid.get_child(i).pressed.connect(func ():
            Sound.play_sfx(Sound.EFFECT.UI_CLICK)
            seed_bag.set_crop(Crop.crop.get(i+1))
        )

func _unhandled_input(event) -> void:
    if event.is_action_pressed("click"):
        match tlm.get_selected_tool():
            tlm.tools.SHOVEL:
                shovel.emit(event.position, seed_bag.get_crop())
            tlm.tools.HOE:
                hoe.emit(event.position)
            tlm.tools.WATERING_CAN:
                water.emit(event.position)
