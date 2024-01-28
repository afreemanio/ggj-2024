extends Node

## This class we be a global singleton that can be used to queue and modify audio (SFX or music).
## It will also be used to player layered music that can be faded in and out.

## The number of total SFX players
const SFX_PLAYER_COUNT : int = 5
const SFX_BUS_NAME : StringName = "SFX"

## Music players
var music_player_primary : AudioStreamPlayer2D
var music_player_secondary : AudioStreamPlayer2D
const MUSIC_BUS_NAME : StringName = "Music"

## Music filters
const MUSIC_PLAYER_SECONDARY_FADE_DB : float = -40.0
var filter_music_is_lowpassed : bool = false

## The queue of SFX to play
var sfx_players_queue : Array = []

## The currently availale SFX players
var sfx_players_available : Array = []

func _ready() -> void:
	# return TO DISABLE SOUND
	# Init SFX players
	for player in SFX_PLAYER_COUNT:
		var new_player : AudioStreamPlayer2D = AudioStreamPlayer2D.new()
		add_child(new_player)
		sfx_players_available.append(new_player)
		new_player.finished.connect(_on_sfx_finished.bind(new_player))
		new_player.bus = SFX_BUS_NAME
		
	# Init primary music player
	music_player_primary = AudioStreamPlayer2D.new()
	add_child(music_player_primary)
	music_player_primary.bus = MUSIC_BUS_NAME
	
	# Init secondary music player
	music_player_secondary = AudioStreamPlayer2D.new()
	add_child(music_player_secondary)
	music_player_secondary.bus = MUSIC_BUS_NAME
	
	# TODO: Remove
	play_music_dual("res://placeholder/lead_place.mp3", "res://placeholder/drum_place.mp3")

func _process(delta: float) -> void:
	# TODO: REMOVE
	if Input.is_action_just_pressed("DOWN"):
		filter_music_primary_focus(true)
	if Input.is_action_just_pressed("UP"):
		filter_music_primary_focus(false)
	if Input.is_action_just_pressed("LEFT"):
		filter_music_lowpass(true)
	if Input.is_action_just_pressed("RIGHT"):
		filter_music_lowpass(false)
	
	if not sfx_players_queue.is_empty() and not sfx_players_available.is_empty():
		sfx_players_available[0].stream = load(sfx_players_queue.pop_front())
		sfx_players_available[0].play()
		sfx_players_available.pop_front()

func _on_sfx_finished(player):
	sfx_players_available.append(player)

func play_sfx(sound : String) -> void:
	sfx_players_queue.append(sound)
	
func play_music_primary(music : String) -> void:
	music_player_primary.stream = load(music)
	music_player_primary.play()

func play_music_secondary(music : String) -> void:
	music_player_secondary.stream = load(music)
	music_player_secondary.play()

func play_music_dual(music_primary : String, music_secondary : String) -> void:
	play_music_primary(music_primary)
	play_music_secondary(music_secondary)
	
func filter_music_primary_focus(enable : bool) -> void:
	var music_tween : Tween = create_tween()
	if enable:
		pass
		 #music_tween.tween_property(music_player_secondary, "volume_db", MUSIC_PLAYER_SECONDARY_FADE_DB, 0.5).from(0.0)
	else:
		pass
		# music_tween.tween_dproperty(music_player_secondary, "volume_db", 0.0, 0.5).from(MUSIC_PLAYER_SECONDARY_FADE_DB)
	
func filter_music_lowpass(enable : bool) -> void:
	var index : int = AudioServer.get_bus_index(MUSIC_BUS_NAME)
	if enable:
		if not filter_music_is_lowpassed:
			AudioServer.add_bus_effect(index, AudioEffectLowPassFilter.new(), 1)
			filter_music_is_lowpassed = true
	else:
		AudioServer.remove_bus_effect(index, 1)
		filter_music_is_lowpassed = false

func change_volume_db(new_volume_db: float, bus: String):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), new_volume_db)
	
