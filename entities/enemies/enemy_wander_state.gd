class_name EnemyWanderState extends State

# Dependencies - if it doesn't have these, it won't work
@export var actor: Enemy
@export var animator: AnimatedSprite2D
@export var vision_cast: RayCast2D

signal found_player

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false)
	pass # Replace with function body.

# Implements enter state:
func _enter_state() -> void:
	set_physics_process(true)
	animator.play("move")
	if actor.velocity == Vector2.ZERO:
		actor.velocity = Vector2.RIGHT.rotated(randf_range(0, TAU)) * actor.max_speed


func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta):
	animator.scale.x = -sign(actor.velocity.x) # flip the sprite to the direction we are moving in
	if animator.scale.x == 0.0: animator.scale.x = 1.0
	var collision = actor.move_and_collide(actor.velocity * delta) # doesn't handle sliding - has to handle delta manually
	if collision:
		var bounce_velocity = actor.velocity.bounce(collision.get_normal())
		actor.velocity = bounce_velocity
	if  not vision_cast.is_colliding():
		found_player.emit()

