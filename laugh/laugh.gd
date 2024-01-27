class_name Laugh extends Node2D

## This class is responsible for controlling the laugh mechanic.
##
## The current "percentage" of the laugh is accessible.
## The speed at which the laugh bar will increment is accessible.
## The laugh bar can be decremented by calling a function.

## Signals related to laughing
signal laugh_started
signal laugh_stopped
signal laugh_time_changed
signal laugh_decremented

## Consts related to laughing
const MAX_PERCENT : float = 100.0
const LAUGH_THRESHOLD_SMALL : float = 25.0
const LAUGH_THRESHOLD_MEDIUM : float = 50.0
const LAUGH_THRESHOLD_LARGE : float = 75.0

## The percentage of the laugh meter
@export var laugh_percentage : float = 0.0:
	set(value):
		laugh_percentage = clamp(value, 0.0, MAX_PERCENT)
	get:
		return laugh_percentage

## The increment time (in seconds) of the laugh meter (from 0% to 100%)
@export var laugh_increment_time : float = 5:
	set(value):
		laugh_increment_time = value
		laugh_time_changed.emit()

## Whether or not the laugh is active (incrementing the bar)
@export var laugh_active : bool = false:
	set(value):
		laugh_active = value
		if (value == true):
			laugh_started.emit()
		else:
			laugh_stopped.emit()

## Execute on ready
func _ready():
	pass


func calculate_laugh_type(laugh_percentage):
	if laugh_percentage == MAX_PERCENT:
		return "MAX"
	elif laugh_percentage > LAUGH_THRESHOLD_LARGE:
		return "LARGE"
	elif laugh_percentage > LAUGH_THRESHOLD_MEDIUM:
		return "MEDIUM"
	elif laugh_percentage > LAUGH_THRESHOLD_SMALL:
		return "SMALL"
	else:
		return "NONE"



## Execute once per physics step (set period of time)
func _physics_process(delta: float) -> void:
	%PercentDebugLabel.text = str(laugh_percentage)
	%TypeDebugLabel.text = calculate_laugh_type(laugh_percentage)
	# If the laugh is enabled, increment the bar by our set time
	if laugh_active:
		laugh_percentage += ((MAX_PERCENT / laugh_increment_time) * delta)
		# If the laugh percentage has reached 100%, force a laugh
		if laugh_percentage == MAX_PERCENT:
			laugh()

## Make the character laugh and decrement the bar
func laugh() -> void:
	# According to the current laugh volume, emit a radial laugh.
	# We activate the appropriate radial laugh scan and return a list of
	# whatever was caught in the scan.
	var overlapping_bodies_array : Array
	if laugh_percentage == MAX_PERCENT:
		print("Max Laugh")
		print("God Damn!")
		print(overlapping_bodies_array)
		pass
	elif laugh_percentage > LAUGH_THRESHOLD_LARGE:
		overlapping_bodies_array = %LargeLaughArea2D.get_overlapping_bodies()
		print("Large")
		print(overlapping_bodies_array)
		pass
	elif laugh_percentage > LAUGH_THRESHOLD_MEDIUM:
		overlapping_bodies_array = %MediumLaughArea2D.get_overlapping_bodies()
		print("Medium")
		print(overlapping_bodies_array)
		pass
	elif laugh_percentage > LAUGH_THRESHOLD_SMALL:
		overlapping_bodies_array = %SmallLaughArea2D.get_overlapping_bodies()
		print("Small")
		print(overlapping_bodies_array)
		pass
	else:
		pass
		
	# Reset the laugh percentage
	laugh_percentage -= 100
	
	# Call the alert function on any guard caught in the radius
	for body in overlapping_bodies_array:
		# if body is PlaceholderEnemy:
		if body is Enemy:
			print("AAAAA")
			# Alerts to sound at player position
			body.alert_to_sound(global_position)
			
	# TODO: Remove placehodler sound
	AudioManager.play_sfx("res://placeholder/sound.wav")
