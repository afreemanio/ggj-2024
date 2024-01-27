class_name BlueGuard extends Enemy

@export var max_speed = 500.0
# @export var acceleration = 50.0
@export var acceleration = 1000.0
@onready var ray_cast_2d = $"RayCast2D"
# temporary code to follow the mouse

@onready var fsm = $FiniteStateMachine as FiniteStateMachine
@onready var enemy_wander_state = $FiniteStateMachine/EnemyWanderState as EnemyWanderState
@onready var enemy_chase_state = $FiniteStateMachine/EnemyChaseState as EnemyChaseState
@onready var enemy_follow_path_state = $FiniteStateMachine/EnemyFollowPathState as EnemyFollowPathState

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



func _on_vision_cone_area_body_entered(body: Node2D) -> void:
	pass
	# print("%s is seeing %s" % [self, body])

func _on_vision_cone_area_body_exited(body: Node2D) -> void:
	pass
	# print("%s stopped seeing %s" % [self, body])
