class_name Player extends CharacterBody2D

## Player speed
@export var speed : int = 150

# Cached previous facing direction of the player
var _previously_moving_right : bool = false
var _is_captured : bool = false
var _is_frozen : bool = false
@onready var audible_area = $AudibleArea2D
var footstepSoundArray = ["res://audio/SFX_PLAYER_FOOT_HH/SFX_PLAYER_FOOT_HH.wav","res://audio/SFX_PLAYER_FOOT_HH/SFX_PLAYER_FOOT_HH_1.wav","res://audio/SFX_PLAYER_FOOT_HH/SFX_PLAYER_FOOT_HH_2.wav","res://audio/SFX_PLAYER_FOOT_HH/SFX_PLAYER_FOOT_HH_3.wav"]
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var footstep_timer = $FootstepTimer



func _ready():
	# Set up initial sprite orientation
	animated_sprite_2d.play("idle")
	animated_sprite_2d.flip_h = true
	
	# Set up freeze
	_is_frozen = false
	
	# Connect to signal singleton
	SignalManager.player_captured.connect(_player_captured)
	
func _physics_process(delta):
	if not _is_captured:
		if not _is_frozen:
			if Input.is_action_just_pressed("SPACE"):
				%Laugh.laugh()
			_update_movement()
			move_and_slide()

## Get player input and update the movement velocity vector
func _update_movement():
	# Get movement direction
	var movement_direction : Vector2 = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	
	# Set sprite
	if movement_direction.x != 0 and movement_direction.y == 0:
		animated_sprite_2d.play("walk_forward")
	elif movement_direction.y < 0:
		animated_sprite_2d.play("walk_up")
	elif movement_direction.y > 0:
		animated_sprite_2d.play("walk_down")
	else:
		animated_sprite_2d.play("idle")
		
	# Flip sprite and cache x-direction
	if _previously_moving_right and movement_direction.x < 0:
		animated_sprite_2d.flip_h = false
		_previously_moving_right = false
	if !_previously_moving_right and movement_direction.x > 0:
		animated_sprite_2d.flip_h = true
		_previously_moving_right = true
		
	velocity = movement_direction * speed
	
		# Sync footstep sound
	if footstep_timer.is_stopped() and animated_sprite_2d.animation != "idle" and animated_sprite_2d.frame == 1:
			footstep_timer.start()
			var footstepToUse = AudioManager.get_random_from_array(footstepSoundArray)
			#print("FOOTSTEP USED IS: ", footstepToUse)
			#print("PLAYING FOOTSTEP IN PLAYER")
			AudioManager.play_sfx(footstepToUse)

## If the player was captured, call this function and do player-related capture stuff here
func _player_captured() -> void:
	_is_captured = true


func _on_laugh_global_laughed() -> void:
	_is_frozen = true
