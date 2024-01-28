class_name Player extends CharacterBody2D

## Player speed
@export var speed : int = 150

# Cached previous facing direction of the player
var _previously_moving_right : bool = false
var _is_captured : bool = false
@onready var audible_area = $AudibleArea2D

func _ready():
	# Set up initial sprite orientation
	%AnimatedSprite2D.play("idle")
	%AnimatedSprite2D.flip_h = true
	
	# Connect to signal singleton
	SignalManager.player_captured.connect(_player_captured)
	
func _physics_process(delta):
	if not _is_captured:
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
		%AnimatedSprite2D.play("walk_forward")
	elif movement_direction.y < 0:
		%AnimatedSprite2D.play("walk_up")
	elif movement_direction.y > 0:
		%AnimatedSprite2D.play("walk_down")
	else:
		%AnimatedSprite2D.play("idle")
		
	# Flip sprite and cache x-direction
	if _previously_moving_right and movement_direction.x < 0:
		%AnimatedSprite2D.flip_h = false
		_previously_moving_right = false
	if !_previously_moving_right and movement_direction.x > 0:
		%AnimatedSprite2D.flip_h = true
		_previously_moving_right = true
		
	velocity = movement_direction * speed

## If the player was captured, call this function and do player-related capture stuff here
func _player_captured() -> void:
	_is_captured = true
