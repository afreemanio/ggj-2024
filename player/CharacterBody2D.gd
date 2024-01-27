extends CharacterBody2D

@export var speed : int = 300

func _ready():
	pass
	
func _physics_process(delta):
	_update_movement()
	move_and_slide()

## Get player input and update the movement velocity vector
func _update_movement():
	var movement_direction : Vector2 = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	velocity = movement_direction * speed
