extends Node2D

## This node is responsible for managing each level.

## Storage of the current level
var current_level_instance : Node2D
var current_level_number : int
var is_resetting : bool = false

func _ready() -> void:
	# Connect signals
	SignalManager.level_changed.connect(load_level)
	SignalManager.player_captured.connect(restart_level)
	SignalManager.game_completed.connect(game_complete)
	
## Called every frame
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("RESTART"):
		restart_level()

## Unload the desired level
func unload_current_level_instance() -> void:
	if is_instance_valid(current_level_instance):
		current_level_instance.queue_free()
	current_level_instance = null

## Load the desired level
func load_level(level_number : int) -> void:
	await %TransitionEffect.fade_black(2)
	print("Loading Level " + str(level_number))
	AudioManager.play_music_primary("res://audio/MX_LEVEL_HH.wav")
	StatManager.guards_alerted = 0
	unload_current_level_instance()
	var level_path : String = "res://world/levels/%s.tscn" % str(level_number)
	var level_resource : PackedScene = load(level_path)
	if level_resource:
		current_level_instance = level_resource.instantiate()
		current_level_number = level_number
		add_child(current_level_instance)
	await %TransitionEffect.unfade_black(2)

## Restart the current level
func restart_level() -> void:
	if is_resetting:
		return
	is_resetting = true
	AudioManager.play_sfx("res://audio/MX_LOSE_STATE_HH.wav")
	await get_tree().create_timer(2.0).timeout
	load_level(current_level_number)
	is_resetting = false

## Complete the game
func game_complete() -> void:
	await %TransitionEffect.fade_black(2)
	unload_current_level_instance
	await %TransitionEffect.unfade_black(2)
