class_name EnemyFoundNoiseQuickSearchState extends State

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
@export var animation_player: AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false)
	pass # Replace with function body.

func _enter_state() -> void:
	print("ENTER STATE FOUND NOISE QUICK SEARCH")
	print(animation_player.get_animation_list())
	animator.play("idle")
	animation_player.play("search_left_and_right")
	set_physics_process(true)


func _exit_state() -> void:
	print("EXIT STATE FOUND NOISE QUICK SEARCH")
	animation_player.stop()
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	# var direction = actor.global_position.direction_to(heard_sound_location)
	# actor.velocity = actor.velocity.move_toward(
	# 	direction * actor.max_speed * max_speed_multiplier, actor.acceleration * delta * acceleration_multiplier
	# )
	# actor.move_and_slide()
	# actor.look_at(global_position + actor.velocity)

	# actor slowly looks left, slowly looks right, then navs back to original path
	# rotation.y = lerp_angle(rotation.y, _target_angle, delta * _rotation_amount)
	# tween.tween_property(pivot, "transform", pivot.transform.rotated(axis, PI/2), 0.5)
	pass


