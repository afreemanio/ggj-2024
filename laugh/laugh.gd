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


@export var epona_meter_starting_value : float = 3.0
# 0 is empty, 1 is one, 2 is 2, 3 is 3 (max)
@export var epona_meter_max : float = 3.0
# regen rate should be number of seconds to go up by 1
@export var epona_meter_regen_rate : float = 4
var epona_meter_value = 0


var smallLaughSoundArray = ["res://audio/SFX_LAUGH_SMALL_HH/SFX_LAUGH_SMALL_HH.wav", "res://audio/SFX_LAUGH_SMALL_HH/SFX_LAUGH_SMALL_HH_1.wav", "res://audio/SFX_LAUGH_SMALL_HH/SFX_LAUGH_SMALL_HH_2.wav", "res://audio/SFX_LAUGH_SMALL_HH/SFX_LAUGH_SMALL_HH_3.wav"  ]
var bigLaughSoundArray = ["res://audio/SFX_LAUGH_BIG_HH/SFX_LAUGH_BIG_HH.wav","res://audio/SFX_LAUGH_BIG_HH/SFX_LAUGH_BIG_HH_1.wav","res://audio/SFX_LAUGH_BIG_HH/SFX_LAUGH_BIG_HH_2.wav"]

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
	epona_meter_value = epona_meter_starting_value
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

func find_laugh_audio_array(laugh_percentage):
	if laugh_percentage == MAX_PERCENT:
		return bigLaughSoundArray
	elif laugh_percentage > LAUGH_THRESHOLD_LARGE:
		return bigLaughSoundArray
	elif laugh_percentage > LAUGH_THRESHOLD_MEDIUM:
		return smallLaughSoundArray
	elif laugh_percentage > LAUGH_THRESHOLD_SMALL:
		return smallLaughSoundArray
	else:
		return smallLaughSoundArray




func decrement_epona_meter():
	var new_value = epona_meter_value - 1
	# make sure it cannot go below 0
	if new_value < 0:
		new_value = 0
	# floor to the nearest integer
	new_value = floor(new_value)
	epona_meter_value = new_value

func increment_epona_meter(delta):
	if epona_meter_value == epona_meter_max:
		return
	if epona_meter_value > epona_meter_max:
		epona_meter_value = epona_meter_max
		return
	# increase epona meter by delta times the regen rate
	# regen rate is the number of seconds to go up by 1
	# so if regen rate is 4, then we go up by 1 every 4 seconds
	epona_meter_value = epona_meter_value + (delta * (1 / epona_meter_regen_rate))

## Execute once per physics step (set period of time)
func _physics_process(delta: float) -> void:
	
	%PercentDebugLabel.text = str(laugh_percentage)
	%TypeDebugLabel.text = calculate_laugh_type(laugh_percentage)
	%EponaMeterDebugLabel.text = str(epona_meter_value)
	increment_epona_meter(delta)

	# If the laugh is enabled, increment the bar by our set time
	if laugh_active:
		laugh_percentage += ((MAX_PERCENT / laugh_increment_time) * delta)
		# If the laugh percentage has reached 100%, force a laugh
		if laugh_percentage == MAX_PERCENT:
			laugh()

## Make the character laugh and decrement the bar
func laugh() -> void:
	# First, check to make sure the laugh is allowed (not already laughing, epona meter is not empty)
	if epona_meter_value < 1:
		# TODO: Play a sound to indicate that the laugh is not allowed
		return
	decrement_epona_meter()

	var laugh_type = calculate_laugh_type(laugh_percentage)

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
	var laughArrayToUse = find_laugh_audio_array(laugh_percentage)
	var laughToUse = AudioManager.get_random_from_array(laughArrayToUse)
	AudioManager.play_sfx(laughToUse)
