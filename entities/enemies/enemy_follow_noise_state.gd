class_name EnemyFollowNoiseState extends State

# Dependencies - if it doesn't have these, it won't work
@export var actor: Enemy
@export var animator: AnimatedSprite2D
@export var vision_cast: RayCast2D

signal found_player
# @export var vision_renderer: Polygon2D
# @export var alert_color: Color

# @export_group("Rotation")
# @export var is_rotating = false
# @export var rotation_speed = 0.1
# @export var rotation_angle = 90

# @export_group("Movement")
# @export var move_on_path: PathFollow2D
# @export var movement_speed = 0.1
@onready var pos_start = position.x

@onready var rot_start = rotation
var heard_sound_location: Vector2
@export var max_speed_multiplier: float = 0.5
@export var acceleration_multiplier: float = 0.5



# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false)
	pass # Replace with function body.

# Implements enter state:
func _enter_state() -> void:
	print("ENTER STATE NOISE FOLLOW")
	heard_sound_location = actor.heard_sound_location_buffer
	actor.heard_sound_location_buffer = Vector2.ZERO
	set_physics_process(true)
	# animator.play("move")
	# if actor.velocity == Vector2.ZERO:
	# 	actor.velocity = Vector2.RIGHT.rotated(randf_range(0, TAU)) * actor.max_speed


func _exit_state() -> void:
	print("EXIT STATE NOISE FOLLOW")
	set_physics_process(false)




func _physics_process(delta: float) -> void:
	# Nav the actor towards the point that they were last seen on
	var direction = actor.global_position.direction_to(heard_sound_location)
	actor.velocity = actor.velocity.move_toward(
		direction * actor.max_speed * max_speed_multiplier, actor.acceleration * delta * acceleration_multiplier
	)
	actor.move_and_slide()
	actor.look_at(global_position + actor.velocity)
	pass



