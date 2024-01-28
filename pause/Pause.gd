extends Control

var is_paused : bool = false

func _ready() -> void:
	hide()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("PAUSE"):
		pause()

func pause():
	if is_paused:
		is_paused = false
		get_tree().paused = false
		hide()
	else:
		is_paused = true
		show()
		get_tree().paused = true
