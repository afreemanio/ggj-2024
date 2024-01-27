class_name PlaceholderEnemy extends CharacterBody2D

func alert() -> void:
	var die_tween : Tween = create_tween()
	die_tween.tween_property(self, "rotation", 360, 1).from(0)
