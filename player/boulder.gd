class_name Boulder
extends RigidBody2D

const MAX_SPEED: float = 1000
const JUMP_FORCE: float = 1000

var on_floor: bool = false


func _input(event):
	if event.is_action_pressed("jump"):
		jump()
	if event.is_action_pressed("restart"):
		GameState.restart_level()


func _physics_process(_delta):
	linear_velocity = linear_velocity.clamp(Vector2(-MAX_SPEED, -INF), Vector2(MAX_SPEED, INF))


func _integrate_forces(state: PhysicsDirectBodyState2D):
	on_floor = false
	
	var i: int = 0
	while i < state.get_contact_count():
		var normal: Vector2 = state.get_contact_local_normal(i)
		var contact_on_floor: bool = normal.dot(Vector2.UP) > 0.9 # Adjust this to tweak which angle it considers a floor
		
		on_floor = on_floor or contact_on_floor
		i += 1


func stop_movement():
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	rotation = 0


func jump():
	if !on_floor: return
	
	apply_central_impulse(Vector2.UP * JUMP_FORCE)
