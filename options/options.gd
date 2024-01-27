class_name OptionsMenu
extends Control

@export var transition : Transition

signal return_pressed

func _ready():
	visible = false


func _on_return_gui_input(event):
	if event.is_action_pressed("CLICK"):
		AudioManager.play_sound(AudioManager.SELECTED)
		transition.close()
		AudioManager.play_sound(AudioManager.CLOSING)
		await transition.transition_completed
		visible = false
		return_pressed.emit()


func _on_sfx_slider_value_changed(value):
	AudioManager.change_volume_db(linear_to_db(value), "SFX")
	AudioManager.play_sound(AudioManager.ADJUSTED)


func _on_music_slider_value_changed(value):
	AudioManager.change_volume_db(linear_to_db(value), "Music")


func _on_title_screen_options_pressed():
	visible = true
	transition.open()
	AudioManager.play_sound(AudioManager.OPENING)
