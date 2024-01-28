class_name EnemyCapturedPlayerState extends State

# Dependencies - if it doesn't have these, it won't work
@export var actor: Enemy
@export var animator: AnimatedSprite2D
@export var vision_cast: RayCast2D

# signal found_player
# @export var vision_renderer: Polygon2D
# @export var alert_color: Color

# @export_group("Rotation")
# @export var is_rotating = false
# @export var rotation_speed = 0.1
# @export var rotation_angle = 90

# @export_group("Movement")
# @export var move_on_path: PathFollow2D
# @export var movement_speed = 0.1
# @onready var pos_start = position.x

# @onready var original_color = vision_renderer.color if vision_renderer else Color.WHITE
# @onready var rot_start = rotation


# Called when the node enters the scene tree for the first time.
func _ready():
	#print("STARTED PATH FOLLOWING")
	set_physics_process(false)
	pass # Replace with function body.

# Implements enter state:
func _enter_state() -> void:
	print("ENTER STATE CAPTURED PLAYER")
	set_physics_process(true)
	animator.play("alert")
	# if actor.velocity == Vector2.ZERO:
	# 	actor.velocity = Vector2.RIGHT.rotated(randf_range(0, TAU)) * actor.max_speed


func _exit_state() -> void:
	print("EXIT STATE CAPTURED PLAYER")
	set_physics_process(false)



func _physics_process(delta: float) -> void:
	pass



