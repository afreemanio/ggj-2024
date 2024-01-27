class_name EnemyFollowPathState extends State

# Dependencies - if it doesn't have these, it won't work
@export var actor: Enemy
@export var animator: AnimatedSprite2D
@export var vision_cast: RayCast2D

signal found_player
@export var vision_renderer: Polygon2D
@export var alert_color: Color

# @export_group("Rotation")
# @export var is_rotating = false
# @export var rotation_speed = 0.1
# @export var rotation_angle = 90

# @export_group("Movement")
# @export var move_on_path: PathFollow2D
# @export var movement_speed = 0.1
@onready var pos_start = position.x

@onready var original_color = vision_renderer.color if vision_renderer else Color.WHITE
@onready var rot_start = rotation


# Called when the node enters the scene tree for the first time.
func _ready():
	#print("STARTED PATH FOLLOWING")
	set_physics_process(false)
	pass # Replace with function body.

# Implements enter state:
func _enter_state() -> void:
	print("ENTER STATE PATH FOLLOW")
	set_physics_process(true)
	# animator.play("move")
	# if actor.velocity == Vector2.ZERO:
	# 	actor.velocity = Vector2.RIGHT.rotated(randf_range(0, TAU)) * actor.max_speed


func _exit_state() -> void:
	set_physics_process(false)

#func _physics_process(delta):
	#animator.scale.x = -sign(actor.velocity.x) # flip the sprite to the direction we are moving in
	#if animator.scale.x == 0.0: animator.scale.x = 1.0
	#var collision = actor.move_and_collide(actor.velocity * delta) # doesn't handle sliding - has to handle delta manually
	#if collision:
		#var bounce_velocity = actor.velocity.bounce(collision.get_normal())
		#actor.velocity = bounce_velocity
	#if not vision_cast.is_colliding():
		#found_player.emit()




func _physics_process(delta: float) -> void:
	if actor.is_rotating:
		actor.rotation = actor.rot_start + sin(Time.get_ticks_msec()/1000. * actor.rotation_speed) * deg_to_rad(actor.rotation_angle/2.)
	if actor.move_on_path:
		# print("MOVING ON PATH")
		# print("GOING TO:")
		# print(actor.move_on_path.position)
		actor.move_on_path.progress += actor.movement_speed
		actor.global_position = actor.move_on_path.position
		actor.rotation = actor.move_on_path.rotation



func _on_vision_cone_area_body_entered(body):
	vision_renderer.color = alert_color
	print("FOUND PLAYER")
	found_player.emit()
	pass # Replace with function body.


func _on_vision_cone_area_body_exited(body):
	vision_renderer.color = original_color
	pass # Replace with function body.
