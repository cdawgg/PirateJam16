class_name Boulder
extends RigidBody2D

const MAX_SPEED: float = 1000
const JUMP_FORCE: float = 1000

@onready var gun: Gun = $Gun

var input_disabled: bool = true
var on_floor: bool = false


func _input(event):
	if input_disabled: return
	
	if event.is_action_pressed("jump"): #jump set to space bar
		jump()
	if event.is_action_pressed("restart"): #restart set to R
		GameState.start_level()
	if event.is_action_pressed("action"): #action set to E, nothing set here yet
		pass
	if event.is_action_pressed("fire_gun"):
		gun.fire()


func _physics_process(delta):
	linear_velocity = linear_velocity.clamp(Vector2(-MAX_SPEED, -INF), Vector2(MAX_SPEED, INF))


func _integrate_forces(state: PhysicsDirectBodyState2D):
	on_floor = false
	
	var i: int = 0
	while i < state.get_contact_count():
		var normal: Vector2 = state.get_contact_local_normal(i)
		var contact_on_floor: bool = normal.dot(Vector2.UP) > 0.9 # Adjust this to tweak which angle it considers a floor
		
		on_floor = on_floor or contact_on_floor
		i += 1


func enable_gun(enable: bool):
	gun.visible = enable
	
	if enable:
		gun.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		gun.process_mode = Node.PROCESS_MODE_DISABLED


func disable_input(val: bool = true):
	input_disabled = val


func stop_movement():
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	rotation = 0
	#TODO add kill boulder if stopped for more than a few secs 


func jump():
	if !on_floor: return
	
	apply_central_impulse(Vector2.UP * JUMP_FORCE)


func _on_body_entered(_body):
	# TODO: Calculate this according to collision vectors instead
	var shake_strength: float = 0.0003 * linear_velocity.length()
	GameState.shake_camera(shake_strength)
