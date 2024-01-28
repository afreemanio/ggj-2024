class_name BlueGuard extends Enemy

@export var max_speed = 500.0
# @export var acceleration = 50.0
# @export var acceleration = 1000.0
# @export var acceleration = 1000000.0 # basically instant movement
@export var acceleration = 1000.0
@export var alert_color: Color
@onready var original_color = vision_renderer.color if vision_renderer else Color.WHITE


@onready var ray_cast_2d = $"RayCast2D"
@onready var fsm = $FiniteStateMachine as FiniteStateMachine
@onready var enemy_wander_state = $FiniteStateMachine/EnemyWanderState as EnemyWanderState
@onready var enemy_chase_state = $FiniteStateMachine/EnemyChaseState as EnemyChaseState
@onready var enemy_follow_path_state = $FiniteStateMachine/EnemyFollowPathState as EnemyFollowPathState
@onready var enemy_follow_noise_state = $FiniteStateMachine/EnemyFollowNoiseState as EnemyFollowNoiseState
@onready var enemy_found_noise_quick_search_state = $FiniteStateMachine/EnemyFoundNoiseQuickSearchState as EnemyFoundNoiseQuickSearchState
@onready var enemy_navigate_back_to_path_state = $FiniteStateMachine/EnemyNavigateBackToPathState as EnemyNavigateBackToPathState
@onready var enemy_captured_player_state = $FiniteStateMachine/EnemyCapturedPlayerState as EnemyCapturedPlayerState
@onready var hitbox = $Hitbox
@onready var vision_renderer = $VisionCone2D/VisionConeRenderer

@onready var heard_sound_location_buffer: Vector2 = Vector2.ZERO



func _ready():
	# connect the enemy wander state found player signal to the
	# change state function in our finite state machine's enemy chase state
	# "when the enemy finds the player, change to the chase state"
	enemy_wander_state.found_player.connect(fsm.change_state.bind(enemy_chase_state))
	enemy_chase_state.lost_player.connect(fsm.change_state.bind(enemy_wander_state))
	enemy_follow_path_state.found_player.connect(fsm.change_state.bind(enemy_chase_state))
	enemy_follow_noise_state.found_noise.connect(fsm.change_state.bind(enemy_found_noise_quick_search_state))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	ray_cast_2d.target_position = get_local_mouse_position()
	
	# Get the global rotation, and convert it to an x-direction
	var rotation_degrees = rad_to_deg(global_rotation)
	if (rotation_degrees > -90) and (rotation_degrees < 90):
		%AnimatedSprite2D.flip_h = true
	else:
		%AnimatedSprite2D.flip_h = false
	print(rotation_degrees)
	%AnimatedSprite2D.global_rotation = 0.0
	pass


func _on_player_hitbox_body_entered(body):
	print("PLAYER CAPTURED")
	fsm.change_state(enemy_captured_player_state)
	SignalManager.player_captured.emit()
	pass # Replace with function body.


func _on_vision_cone_area_body_entered(body):
	print("PLAYER SPOTTED")
	vision_renderer.color = alert_color
	if fsm.state != enemy_chase_state || fsm.state != enemy_captured_player_state:
		fsm.change_state(enemy_chase_state)
	# fsm.change_state.bind(enemy_chase_state)
	pass # Replace with function body.


func _on_vision_cone_area_body_exited(body):
	vision_renderer.color = original_color
	pass # Replace with function body.


func alert_to_sound(sound_position: Vector2):
	heard_sound_location_buffer = sound_position
	fsm.change_state(enemy_follow_noise_state)



func _on_sound_hitbox_body_entered(body):
	print("SOUND SOURCE FOUND")
	fsm.change_state(enemy_found_noise_quick_search_state)
	pass # Replace with function body.


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "search_left_and_right":
		print("SEARCH ANIMATION COMPLETE")
		fsm.change_state(enemy_navigate_back_to_path_state)
	pass # Replace with function body.


func _on_path_return_hitbox_body_entered(body):
	print("PATH FOUND")
	fsm.change_state(enemy_follow_path_state)
	pass # Replace with function body.
