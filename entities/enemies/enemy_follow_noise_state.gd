class_name EnemyFollowNoiseState extends State

# Dependencies - if it doesn't have these, it won't work
@export var actor: Enemy
@export var animator: AnimatedSprite2D
@export var vision_cast: RayCast2D

signal found_noise
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
var heard_sound_location: Node2D
@export var max_speed_multiplier: float = 0.5
@export var acceleration_multiplier: float = 0.5


# @onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@export var nav_agent: NavigationAgent2D



# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false)
	pass # Replace with function body.


func create_noise_location_node(creation_location: Vector2) -> void:
	if heard_sound_location != null:
		heard_sound_location.queue_free()
	heard_sound_location = StaticBody2D.new()
	heard_sound_location.name = "Heard Sound Location"
	heard_sound_location.position = creation_location
	heard_sound_location.add_to_group("noise_location")
	heard_sound_location.set_collision_layer_value(1, false)
	heard_sound_location.set_collision_layer_value(5, true)
	# heard_sound_location.set_collision_mask_value(3, true)
	create_collision_on_location_node()
	get_tree().get_root().add_child(heard_sound_location)


func create_collision_on_location_node() -> void:
	var collision = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = 1
	collision.shape = circle
	# Set layer to 5
	heard_sound_location.add_child(collision)


func delete_noise_location_node() -> void:
	heard_sound_location.queue_free()


# Implements enter state:
func _enter_state() -> void:
	print("ENTER STATE NOISE FOLLOW")
	# heard_sound_location = actor.heard_sound_location_buffer
	create_noise_location_node(actor.heard_sound_location_buffer)
	actor.heard_sound_location_buffer = Vector2.ZERO
	makepath()
	set_physics_process(true)
	animator.play("move")
	# if actor.velocity == Vector2.ZERO:
	# 	actor.velocity = Vector2.RIGHT.rotated(randf_range(0, TAU)) * actor.max_speed


func _exit_state() -> void:
	print("EXIT STATE NOISE FOLLOW")
	delete_noise_location_node()
	set_physics_process(false)


# Need to detect if the hitbox is on the noise cone

func makepath():
	nav_agent.target_position = heard_sound_location.global_position
	# nav_agent.target_position = Vector2.ZERO
	# print("Nav agent target position is now", nav_agent.target_position)


func _physics_process(delta: float) -> void:


	# var direction = actor.to_local(nav_agent.get_next_path_position()).normalized()
	var direction = nav_agent.get_next_path_position()
	var localdirection = actor.global_position.direction_to(direction)
	# print("actor position is", actor.position)
	# print("Direction is now", direction)
	# print("localDirection is now", localdirection)

	# # Nav the actor towards the point that they were last seen on
	actor.velocity = actor.velocity.move_toward(
		localdirection * actor.max_speed * max_speed_multiplier, actor.acceleration * delta * acceleration_multiplier
	)
	actor.move_and_slide()
	actor.look_at(global_position + actor.velocity)
	pass



