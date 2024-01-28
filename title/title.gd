extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Main.show()
	%Option.hide()
	%Credits.hide()
	%WinScreen.hide()
	
	# Conenct to game complete signal
	SignalManager.game_completed.connect(show_victory)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("CLICK"):
		SignalManager.level_changed.emit(1)
		await %TransitionEffect.fade_black(2)
		%Main.hide()
		%Option.hide()
		%Credits.hide()
		%WinScreen.hide()
		%TransitionEffect.unfade_black(2)
		


func _on_option_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("CLICK"):
		await %TransitionEffect.fade_black(2)
		%Main.hide()
		%Option.show()
		%Credits.hide()
		%WinScreen.hide()
		await %TransitionEffect.unfade_black(2)


func _on_return_button_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("CLICK"):
		show_title()


func _on_music_slider_value_changed(value: float) -> void:
	AudioManager.change_volume_db(linear_to_db(value), "Music")


func _on_sfx_slider_drag_ended(value_changed: bool) -> void:
	AudioManager.change_volume_db(linear_to_db(%SFXSlider.value), "SFX")
	AudioManager.play_sfx("res://audio/UI_SELECT_HH.wav")

func show_title() -> void:
	await %TransitionEffect.fade_black(2)
	%Main.show()
	%Option.hide()
	%Credits.hide()
	%WinScreen.hide()
	await %TransitionEffect.unfade_black(2)

func show_credits() -> void:
	await %TransitionEffect.fade_black(2)
	%Main.hide()
	%Option.hide()
	%Credits.show()
	%WinScreen.hide()
	await %TransitionEffect.unfade_black(2)
	
func show_victory() -> void:
	await %TransitionEffect.fade_black(2)
	%Main.hide()
	%Option.hide()
	%Credits.hide()
	%WinScreen.show()
	await %TransitionEffect.unfade_black(2)
	await get_tree().create_timer(8.0).timeout
	show_credits()

func _on_replay_button_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("CLICK"):
		show_title()
