class_name Goal extends Node2D

@export var level_to_load : int

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_class("CharacterBody2D"):
		SignalManager.level_changed.emit(level_to_load)
