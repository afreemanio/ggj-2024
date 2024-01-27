class_name TitleScreen
extends Control

@export var transition : Transition

@onready var title : TextureRect = $VBoxContainer/MarginContainerTitle/Title
@onready var start : TextureRect = $VBoxContainer/HBoxContainer/MarginContainerStart/Start
@onready var options : TextureRect = $VBoxContainer/HBoxContainer/MarginContainerStart2/Options
@onready var credits: TextureRect = $VBoxContainer/Credits
@onready var animation_player = $AnimationPlayer
@onready var hs: Label = $VBoxContainer/HS

signal start_pressed
signal options_pressed
signal credits_pressed

var high_score : int = 0
var save_path : String = "user://score.save"

func _ready():
	load_score()
	hs.hide()
	AudioManager.play_music(AudioManager.TWO_LEFT_SOCKS_BY_CONGUS_BONGUS_ON_OPENGAMEART)
	

func _process(delta):
	if high_score > 0:
		hs.show()
		hs.text = "HIGH SCORE: " + str(high_score)


func rotate_animation(to_animate: TextureRect):
	pass


func _on_start_gui_input(event):
	if event.is_action_pressed("CLICK"):
		AudioManager.play_sound(AudioManager.SELECTED)
		transition.close()
		AudioManager.play_sound(AudioManager.CLOSING)
		await transition.transition_completed
		visible = false
		start_pressed.emit()


func _on_options_gui_input(event):
	if event.is_action_pressed("CLICK"):
		AudioManager.play_sound(AudioManager.SELECTED)
		transition.close()
		AudioManager.play_sound(AudioManager.CLOSING)
		await transition.transition_completed
		visible = false
		options_pressed.emit()


func _on_options_return_pressed():
	visible = true
	transition.open()
	AudioManager.play_sound(AudioManager.OPENING)


func _on_level_manager_game_ended(score : int):
	visible = true
	if score > high_score:
		high_score = score
		save_score(high_score)
	transition.open()
	AudioManager.play_music(AudioManager.TWO_LEFT_SOCKS_BY_CONGUS_BONGUS_ON_OPENGAMEART)
	AudioManager.play_sound(AudioManager.OPENING)

func save_score(score : int):
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(score)

func load_score():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		high_score = file.get_var()
	else:
		high_score = 0


func _on_credits_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("CLICK"):
		AudioManager.play_sound(AudioManager.SELECTED)
		transition.close()
		AudioManager.play_sound(AudioManager.CLOSING)
		await transition.transition_completed
		visible = false
		credits_pressed.emit()


func _on_credits_return_pressed() -> void:
	visible = true
	transition.open()
	AudioManager.play_sound(AudioManager.OPENING)
