extends Node2D

## This node is responsible for managing each level.

## Storage of the current level
var current_level_instance : Node2D
var current_level_number : int

func _ready() -> void:
	# Connect signals
	SignalManager.level_changed.connect(load_level)
	SignalManager.player_captured.connect(restart_level)
	
## Called every frame
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("RESTART"):
		restart_level()

## Unload the desired level
func unload_current_level_instance() -> void:
	if is_instance_valid(current_level_instance):
		current_level_instance.queue_free()
	current_level_instance = null
	await %TransitionEffect.fade_black()

## Load the desired level
func load_level(level_number : int) -> void:
	print("Loading Level " + str(level_number))
	unload_current_level_instance()
	var level_path : String = "res://world/levels/%s.tscn" % str(level_number)
	var level_resource : PackedScene = load(level_path)
	if level_resource:
		current_level_instance = level_resource.instantiate()
		current_level_number = level_number
		add_child(current_level_instance)
		await %TransitionEffect.unfade_black()

## Restart the current level
func restart_level() -> void:
	load_level(current_level_number)
