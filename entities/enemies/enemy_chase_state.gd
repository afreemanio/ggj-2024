class_name EnemyChaseState extends State

@export var actor: Enemy
@export var animator: AnimatedSprite2D
@export var vision_cast: RayCast2D
@export var max_speed_multiplier: float = 1.5
@export var acceleration_multiplier: float = 20


signal lost_player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_physics_process(false)
	pass  # Replace with function body.


func _enter_state() -> void:
	print("ENTER STATE CHASE")
	set_physics_process(true)
	animator.play("alert")


func _exit_state() -> void:
	print("EXIT STATE CHASE")
	set_physics_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# ! We want him to nav to the player's current location
	# animator.scale.x = -sign(actor.velocity.x)
	# if animator.scale.x == 0.0:
	# 	animator.scale.x = 1.0

	# actor's position, mouse position relative to the actor (GLOBAL is relative to the global base)
	# var direction = Vector2.ZERO.direction_to(target.position)
	# ! direction is direction between actor and player
	var direction = actor.global_position.direction_to(actor.target.global_position)
	actor.velocity = actor.velocity.move_toward(
		direction * actor.max_speed * max_speed_multiplier, actor.acceleration * delta * acceleration_multiplier
	)
	actor.move_and_slide()
	actor.look_at(global_position + actor.velocity)
	#if vision_cast.is_colliding():
		#lost_player.emit()
	pass
