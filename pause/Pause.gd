extends Control

var is_paused : bool = false

func _ready() -> void:
	hide()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("PAUSE"):
		pause()

var audiotime = 0

func pause():

	if is_paused:
		AudioManager.play_sfx("res://audio/UI_RESUME_HH.wav")
		AudioManager.play_music_primary("res://audio/MX_LEVEL_HH.wav", audiotime)
		audiotime = 0
		is_paused = false
		get_tree().paused = false
		hide()
	else:
		AudioManager.play_sfx("res://audio/UI_PAUSE_HH.wav")
		audiotime = AudioManager.music_player_primary.get_playback_position()
		AudioManager.music_player_primary.stop()
		# await get_tree().create_timer(0.55).timeout
		is_paused = true
		show()
		get_tree().paused = true
