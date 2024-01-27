class_name Goal extends Node2D

@export var level_to_load : int = 0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_class("Player"):
		SignalManager.level_changed.emit(level_to_load)
	
