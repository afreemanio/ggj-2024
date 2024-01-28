class_name Goal extends Node2D

@export var level_to_load : int
@export var is_final : bool

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("AREA ENTERED")
	# if body.is_class("Player"):
	if body is Player:
		if not is_final:
			print("EMITTING LEVEL LOAD")
			SignalManager.level_changed.emit(level_to_load)
		if is_final:
			SignalManager.game_completed.emit()
