class_name Player extends CharacterBody2D

@export var speed : int = 150

var previously_moving_right : bool = false

func _ready():
	%AnimatedSprite2D.play("idle")
	%AnimatedSprite2D.flip_h = true
	
func _physics_process(delta):
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
		print("Forward")
	elif movement_direction.y < 0:
		%AnimatedSprite2D.play("walk_up")
		print("Up")
	elif movement_direction.y > 0:
		%AnimatedSprite2D.play("walk_down")
		print("Down")
	else:
		%AnimatedSprite2D.play("idle")
		print("Idle")
		
	# Flip sprite and cache x-direction
	if previously_moving_right and movement_direction.x < 0:
		%AnimatedSprite2D.flip_h = false
		previously_moving_right = false
	if !previously_moving_right and movement_direction.x > 0:
		%AnimatedSprite2D.flip_h = true
		previously_moving_right = true
		
	velocity = movement_direction * speed
