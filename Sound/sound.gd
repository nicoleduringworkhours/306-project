extends Node

## handle playing sound effects and background music

var master_vol: float = 1 ## overall volume

## music player and volume
var music: AudioStreamPlayer
var music_vol: float = 1

## sfx player and volume
var sfx: AudioStreamPlayer
var sfx_vol: float = 1

enum BUS {MASTER, MUSIC, SFX}
enum EFFECT {UI_CLICK, MENU, INTERACT, GROW, TOOL_SWAP}

## map names to sound effects
var sfx_lib: Dictionary = {
        EFFECT.UI_CLICK: preload("res://Assets/Sounds/click.mp3"),
        EFFECT.MENU: preload("res://Assets/Sounds/menu.mp3"),
        EFFECT.INTERACT: preload("res://Assets/Sounds/dirt.mp3"),
        EFFECT.GROW: preload("res://Assets/Sounds/powerup.mp3"),
        EFFECT.TOOL_SWAP: preload("res://Assets/Sounds/chime.mp3"),
    }

## initialize audio buses and players
func _ready() -> void:
    # Music bus set up
    music = AudioStreamPlayer.new()
    music.set_autoplay(true)
    music.set_bus("Music")
    # hack since bgm.wav cannot be set to repeat (for some reason?)
    music.finished.connect(_repeat)

    # music happens always
    music.process_mode = Node.PROCESS_MODE_ALWAYS

    var music_load = load("res://Assets/Sounds/bgm.wav")

    music.set_stream(music_load)

    add_child(music)

    # SFX bus set up
    sfx = AudioStreamPlayer.new()
    sfx.set_bus("SFX")
    # polyphonic bus to play many sounds
    sfx.set_stream(AudioStreamPolyphonic.new())

    add_child(sfx)

## repeat background audio.
func _repeat() -> void:
    music.play()

## set the volume of the bus [param bus] to volume [param volume]
## given as a linear value from 0-1
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

## change the volume of the bus [param bus] by volume [param volume]
## given as a linear value from 0-1
func add_vol(bus: BUS, volume: float):
    match bus:
        BUS.MASTER:
            master_vol = clampf(master_vol + volume, 0, 1)
            AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(master_vol))
        BUS.MUSIC:
            music_vol = clampf(music_vol + volume, 0, 1)
            AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(music_vol))
        BUS.SFX:
            sfx_vol = clampf(sfx_vol + volume, 0, 1)
            AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(sfx_vol))

## play the sound effect [param effect]
func play_sfx(effect: EFFECT):
    if not sfx.playing:
        sfx.play()
    sfx.get_stream_playback().play_stream(sfx_lib[effect])

## get the current volume of the bus [param bus]
func get_vol(bus: BUS) -> float:
    var v: float = 0
    match bus:
        BUS.MASTER:
            v = master_vol
        BUS.MUSIC:
            v = music_vol
        BUS.SFX:
            v = sfx_vol
    return v
