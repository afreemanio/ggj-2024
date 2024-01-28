extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_music_primary("res://audio/MX_MENU_HH.wav")
	%Main.show()
	%Option.hide()
	%Credits.hide()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("CLICK"):
		AudioManager.play_sfx("res://audio/UI_START_HH.wav")
		AudioManager.pause_music_primary() 
		await get_tree().create_timer(2.0).timeout
		
		SignalManager.level_changed.emit(1)
		AudioManager.play_music_primary("res://audio/MX_LEVEL_HH.wav")
		hide()


func _on_option_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("CLICK"):
		#await %TransitionEffect.fade_black()
		%Main.hide()
		%Option.show()
		%Credits.hide()
		AudioManager.play_sfx("res://audio/UI_SELECT_HH.wav")
		#await %TransitionEffect.unfade_black()


func _on_return_button_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("CLICK"):
		show_title()
		AudioManager.play_sfx("res://audio/UI_SELECT_HH.wav")


func _on_music_slider_value_changed(value: float) -> void:
	AudioManager.change_volume_db(linear_to_db(value), "Music")


func _on_sfx_slider_drag_ended(value_changed: bool) -> void:
	AudioManager.change_volume_db(linear_to_db(%SFXSlider.value), "SFX")
	AudioManager.play_sfx("res://audio/UI_SELECT_HH.wav")

func show_title() -> void:
	#await %TransitionEffect.fade_black()
	%Main.show()
	%Option.hide()
	%Credits.hide()
	#await %TransitionEffect.unfade_black()

func show_credits() -> void:
	#await %TransitionEffect.fade_black()
	%Main.hide()
	%Option.hide()
	%Credits.show()
	#await %TransitionEffect.unfade_black()

func _on_replay_button_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("CLICK"):
		show_title()
