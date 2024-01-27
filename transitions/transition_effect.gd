class_name TransitionEffect extends CanvasLayer

func fade_black() -> void:
	%AnimationPlayer.play("fade_black")
	await %AnimationPlayer.animation_finished
	
func unfade_black() -> void:
	%AnimationPlayer.play_backwards("fade_black")
	await %AnimationPlayer.animation_finished
