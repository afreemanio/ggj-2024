extends Node2D

## This node is responsible for managing each level.

var current_level_instance : Node2D

## Unload the desired level
func unload_current_level_instance() -> void:
	if is_instance_valid(current_level_instance):
		current_level_instance.queue_free()
	current_level_instance = null

## Load the desired level
func load_level(level_number : String) -> void:
	unload_current_level_instance()
	var level_path : String = "res://world/levels/%s.tscn" % level_number
	var level_resource : Resource = load(level_path)
	if level_resource:
		current_level_instance = level_resource.instance()
		add_child(current_level_instance)
