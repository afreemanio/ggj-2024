extends CharacterBody2D

@export var speed : int = 300

func _ready():
	pass
	
func _physics_process(delta):
	## Get player input and move in a direction
	var movement_direction : Vector2 = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	velocity = movement_direction * speed
	print(velocity)
	move_and_slide()
