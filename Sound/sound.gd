extends Node

var master_vol: float = 1

var music: AudioStreamPlayer
var music_vol: float = 1

var sfx: AudioStreamPlayer
var sfx_vol: float = 1

enum BUS {MASTER, MUSIC, SFX}
enum EFFECT {UI_CLICK, MENU, INTERACT, GROW, TOOL_SWAP}

var sfx_lib: Dictionary = {
        EFFECT.UI_CLICK: preload("res://Sound/rat.wav"),
        EFFECT.MENU: preload("res://Sound/fire.wav"),
        EFFECT.INTERACT: preload("res://Sound/fire.wav"),
        EFFECT.GROW: preload("res://Sound/fire.wav"),
        EFFECT.TOOL_SWAP: preload("res://Sound/fire.wav"),
    }

func _ready() -> void:
    # Music bus set up
    music = AudioStreamPlayer.new()
    music.set_autoplay(true)
    music.set_bus("Music")
    music.finished.connect(_repeat)

    var music_load = load("res://Sound/bgm.wav")
    music.set_stream(music_load)

    add_child(music)

    # SFX bus set up
    sfx = AudioStreamPlayer.new()
    sfx.set_bus("SFX")
    sfx.set_stream(AudioStreamPolyphonic.new())

    add_child(sfx)

## repeat background audio.
func _repeat() -> void:
    music.play()

func set_vol(bus: BUS, volume: float):
    volume = clampf(volume, 0, 1)
    match bus:
        BUS.MASTER:
            master_vol = volume
            AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(master_vol))
        BUS.MUSIC:
            music_vol = volume
            AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(music_vol))
        BUS.SFX:
            sfx_vol = volume
            AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(sfx_vol))

func add_vol(bus: BUS, volume: float):
    match bus:
        BUS.MASTER:
            master_vol = clampf(master_vol + volume, 0, 1)
            AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(master_vol))
        BUS.MUSIC:
            music_vol = clampf(music_vol + volume, 0, 1)
            AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(music_vol))
        BUS.SFX:
            sfx_vol += volume
            sfx_vol = clampf(sfx_vol + volume, 0, 1)
            AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(sfx_vol))

func play_sfx(effect: EFFECT):
    if not sfx.playing:
        sfx.play()
    sfx.get_stream_playback().play_stream(sfx_lib[effect])

# TODO: temp
func _input(event):
    if event.is_action_pressed("click"):
        play_sfx(EFFECT.INTERACT)
    if event.is_action_pressed("hotkey_1"):
        play_sfx(EFFECT.UI_CLICK)
    if event.is_action_pressed("hotkey_2"):
        add_vol(BUS.MASTER, -0.05)
    if event.is_action_pressed("hotkey_3"):
        add_vol(BUS.MASTER, +0.05)
