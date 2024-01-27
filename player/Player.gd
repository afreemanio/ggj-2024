class_name Player extends CharacterBody2D

@export var speed : int = 300

func _ready():
	## TODO: Maybe can be removed
	# %PhantomCamera2D.set_follow_target_node(%CharacterBody2D)
	%PhantomCamera2D.is_active()
	
func _physics_process(delta):
	if Input.is_action_just_pressed("SPACE"):
		%Laugh.laugh()
	
	_update_movement()
	move_and_slide()

## Get player input and update the movement velocity vector
func _update_movement():
	var movement_direction : Vector2 = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	velocity = movement_direction * speed
