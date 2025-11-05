extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    var tlm = $"ToolMenu/Tool container"
    var sb = $SeedBag
    tlm.tool_selected.connect(sb._tool_selected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
