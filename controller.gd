extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    var tlm = $"ToolMenu/Tool container"
    var sb = $SeedBag
    tlm.tool_selected.connect(sb._tool_selected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

signal water(earl: Vector2)
signal hoe(earl: Vector2)
signal shovel(earl: Vector2, bert: GameManager.sc)

func _unhandled_input(event) -> void:
    if event.is_action_pressed("click"):
        match tlm.get_selected_tool():
            "shovel":
                shovel.emit(event.position, GameManager.get_selected_crop())
            "hoe":
                hoe.emit(event.position)
            "water":
                water.emit(event.position)
