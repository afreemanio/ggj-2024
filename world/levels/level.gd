extends Node2D

## Search for the goal tile in a tilemap and set it to the exported level property
@export var next_level : int = 1

func _ready() -> void:
	for child in get_children():
		if child.is_class("Goal"):
			child.level_to_load = next_level
