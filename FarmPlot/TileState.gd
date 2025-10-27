class_name TileState

enum GroundType {GRASS=0, DIRT=1, WET_DIRT=2} ## States of tiles
    
var ground: GroundType
var seed_type: int
var growth: float
# Constructor / initializer
func _init(_ground: GroundType = GroundType.GRASS, _seed: int = 0, _growth: float = 0.0) -> void:
        ground = _ground
        seed_type = _seed
        growth = _growth

func stimulate_growth(delta: float) -> void:
    growth += delta * 0.1; # magic constant
    if growth >= 1.0:
        growth = 1.0;         
