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
@onready var enemy_captured_player_state = $FiniteStateMachine/EnemyCapturedPlayerState as EnemyCapturedPlayerState
@onready var hitbox = $Hitbox
@onready var vision_renderer = $VisionCone2D/VisionConeRenderer




func _ready():
	# connect the enemy wander state found player signal to the
	# change state function in our finite state machine's enemy chase state
	# "when the enemy finds the player, change to the chase state"
	enemy_wander_state.found_player.connect(fsm.change_state.bind(enemy_chase_state))
	enemy_chase_state.lost_player.connect(fsm.change_state.bind(enemy_wander_state))
	enemy_follow_path_state.found_player.connect(fsm.change_state.bind(enemy_chase_state))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	ray_cast_2d.target_position = get_local_mouse_position()
	pass


func _on_hitbox_body_entered(body):
	print("PLAYER CAPTURED")
	fsm.change_state(enemy_captured_player_state)
	pass # Replace with function body.


func _on_vision_cone_area_body_entered(body):
	vision_renderer.color = alert_color
	if fsm.state != enemy_chase_state || fsm.state != enemy_captured_player_state:
		fsm.change_state(enemy_chase_state)
	# fsm.change_state.bind(enemy_chase_state)
	pass # Replace with function body.


func _on_vision_cone_area_body_exited(body):
	vision_renderer.color = original_color
	pass # Replace with function body.


