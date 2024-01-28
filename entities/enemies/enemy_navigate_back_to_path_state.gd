class_name EnemyNavigateBackToPathState extends State


# Dependencies - if it doesn't have these, it won't work
@export var actor: Enemy
@export var animator: AnimatedSprite2D

signal found_path
@onready var pos_start = position.x

@onready var rot_start = rotation
var path_return_location: Node2D
@export var max_speed_multiplier: float = 0.5
@export var acceleration_multiplier: float = 0.5
@export var nav_agent: NavigationAgent2D


# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false)
	pass # Replace with function body.


func find_closest_abs_pos_to_path(
	path: Path2D,
	global_pos: Vector2
):
	var curve: Curve2D = path.curve

	# transform the target position to local space
	var path_transform: Transform2D = path.global_transform
	var local_pos: Vector2 = global_pos * path_transform

	# get the nearest offset on the curve
	var offset: float = curve.get_closest_offset(local_pos)

	# get the local position at this offset
	var curve_pos: Vector2 = curve.sample_baked(offset, true)

	# transform it back to world space
	curve_pos = path_transform * curve_pos

	return curve_pos


func create_path_location_node(creation_location: Vector2) -> void:
	if path_return_location != null:
		path_return_location.queue_free()
	path_return_location = StaticBody2D.new()
	path_return_location.name = "Home Path Location"
	path_return_location.position = creation_location
	path_return_location.add_to_group("path_location")
	path_return_location.set_collision_layer_value(1, false)
	path_return_location.set_collision_layer_value(6, true)
	# path_return_location.set_collision_mask_value(3, true)
	create_collision_on_location_node()
	get_tree().get_root().add_child(path_return_location)


func create_collision_on_location_node() -> void:
	var collision = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = 1
	collision.shape = circle
	# Set layer to 5
	path_return_location.add_child(collision)


func delete_path_location_node() -> void:
	path_return_location.queue_free()

func makepath():
	nav_agent.target_position = path_return_location.global_position
	# nav_agent.target_position = Vector2.ZERO
	# print("Nav agent target position is now", nav_agent.target_position)




# Implements enter state:
func _enter_state() -> void:
	print("ENTER STATE PATH RETURN")
	# Find location closest to home path
	# var curve_pos = find_closest_abs_pos_to_path(actor.move_on_path.get_parent(), actor.global_position)
	var curve_pos = actor.move_on_path.position
	print("Trying to nav to: " + str(curve_pos))
	create_path_location_node(curve_pos)
	actor.heard_sound_location_buffer = Vector2.ZERO
	makepath()
	set_physics_process(true)


func _exit_state() -> void:
	print("EXIT STATE PATH RETURN")
	delete_path_location_node()
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	if nav_agent.is_navigation_finished():
		makepath()
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




