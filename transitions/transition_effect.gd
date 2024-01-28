class_name TransitionEffect extends CanvasLayer

func fade_black(seconds : float = 1.0) -> void:
	show()
	%AnimationPlayer.play("fade_black", -1, seconds)
	await %AnimationPlayer.animation_finished
	
func unfade_black(seconds : float = 1.0) -> void:
	%AnimationPlayer.play("unfade_black", -1, seconds)
	await %AnimationPlayer.animation_finished
	hide()
