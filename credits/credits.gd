class_name CreditsMenu
extends Control

@export var transition : Transition

signal return_pressed

func _ready():
	visible = false

func _on_return_gui_input(event):
	if event.is_action_pressed("CLICK"):
		# AudioManager.play_sound(AudioManager.SELECTED)
		transition.close()
		# AudioManager.play_sound(AudioManager.CLOSING)
		await transition.transition_completed
		visible = false
		return_pressed.emit()

func _on_title_screen_credits_pressed():
	visible = true
	transition.open()
	# AudioManager.play_sound(AudioManager.OPENING)
