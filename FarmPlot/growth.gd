class_name Growth
extends TileMapLayer

# Model

## non-timeout based states, of the form (state, action): state

var tm: TM_Manager

## set-up. Creates a TM_Manager model, does initial renders of all tiles
## actions on tiles
func _init(tset: TileSet, tminput: TM_Manager) -> void:
    tm = tminput
    self.tile_set = tset

    #Needs to look twice as big ahhh moment
    #cell

    tm.cell_update.connect(_cell_update);
    for i in range(tm.get_rows()):
        for j in range(tm.get_cols()):
            #-1 just means don't render
            set_cell(Vector2i(j,i), -1, Vector2i(tm.get_tile(j,i).ground, 0))

func get_cell_status(x: int, y: int) -> Array:
    var t = local_to_map(Vector2(x,y));
    return [tm.get_tile(t.x, t.y).seed_type, tm.get_tile(t.x, t.y).growth];

func tilestate_to_tilemap_pos(state: TileState) -> Vector2i:
    if state.seed_type == -1:
        return Vector2i(-1, -1); 
    ##This entire math is all simply based on the way Crop_Spritesheet.png
    ##is setup, it is not meaningful and can be replaced in lieu of any
    ##other structure. That's why TileState has seed type and normalized float
    ##for growth. 
    var row = state.seed_type % 10;
    var col = 5 + ((state.seed_type / 10) * 6);
    col -= (state.growth * 5.98);
    return Vector2i(col, row);

# View

## signal handler to deal with visual updates.
func _cell_update(x: int, y: int, state: TileState) -> void:
    set_cell(Vector2i(x,y), 1, tilestate_to_tilemap_pos(state));

# Controller

#var test_seed: int

## Temporary input handling.
func shovel_press(loc: Vector2, seed_selected: SeedBag.crop):
    var a = local_to_map(to_local(loc))
    Sound.play_sfx(Sound.EFFECT.INTERACT)

    var to_plant = 9
    match seed_selected:
        SeedBag.crop.CORN:
            to_plant = 9
        SeedBag.crop.POTATO:
            to_plant = 7
        SeedBag.crop.WHEAT:
            to_plant = 5

    tm.plant_seed(a.x,a.y, to_plant, 0.0)

#func _input(event) -> void:
#    # temporary input handling for testing.
#
#    if event.is_action_pressed("hotkey_2"):
#        var a = local_to_map(get_viewport().get_mouse_position())
#        Sound.play_sfx(Sound.EFFECT.INTERACT)
#        tm.plant_seed(a.x,a.y, test_seed, 0.0)
#        test_seed += 1;
#        test_seed %= 20;
