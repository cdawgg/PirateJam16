class_name Boulder
extends RigidBody2D

const MAX_SPEED: float = 400
const JUMP_FORCE: float = 400
const ACCEL_FORCE: float = 300

@onready var gun: Gun = $Gun

var input_disabled: bool = true

var on_floor: bool = false
var floor_grace_timer: Timer
var floor_grace_ready: bool = true
const FLOOR_GRACE_PERIOD: float = 0.2

var extra_jumps: int = 0
var rem_extra_jumps: int = extra_jumps
var jump_cd: Timer
var jump_cd_ready: bool = true
const JUMP_CD_LENGTH: float = 0.3


func _ready():
	jump_cd = Timer.new()
	jump_cd.timeout.connect(_on_jump_cd_timeout)
	add_child(jump_cd)
	
	floor_grace_timer = Timer.new()
	floor_grace_timer.timeout.connect(_on_floor_grace_timer_timeout)
	add_child(floor_grace_timer)


func _input(event):
	if event.is_action_pressed("restart"): #restart set to R
		GameState.restart_level()
	
	if input_disabled: return
	
	if event.is_action_pressed("jump"): #jump set to space bar
		jump()
	if event.is_action_pressed("action"): #action set to E, nothing set here yet
		pass
	if event.is_action_pressed("fire_gun"):
		gun.fire()
	if event.is_action_pressed("debug_kill"):
		die()


func _physics_process(delta):
	if !input_disabled:
		if Input.is_action_pressed("accelerate"):
			linear_velocity.x += ACCEL_FORCE * delta
			$Sprite2D.rotation += 5 * delta
		elif Input.is_action_pressed("decelerate"):
			linear_velocity.x -= ACCEL_FORCE * delta
			$Sprite2D.rotation -= 5 * delta
	
	linear_velocity = linear_velocity.clamp(Vector2(-MAX_SPEED, -INF), Vector2(MAX_SPEED, INF))


func _integrate_forces(state: PhysicsDirectBodyState2D):
	on_floor = check_on_floor(state)


func check_on_floor(state: PhysicsDirectBodyState2D) -> bool:
	if !floor_grace_ready: return true
	if !jump_cd_ready: return false
	
	var i: int = 0
	while i < state.get_contact_count():
		var normal: Vector2 = state.get_contact_local_normal(i)
		var contact_on_floor: bool = normal.dot(Vector2.UP) > 0.9 # Adjust this to tweak which angle it considers a floor
		
		if contact_on_floor:
			rem_extra_jumps = extra_jumps
			floor_grace_ready = false
			floor_grace_timer.start(FLOOR_GRACE_PERIOD)
			return true
		
		i += 1
	
	return false


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
	if !jump_cd_ready: return
	
	if !on_floor:
		if rem_extra_jumps > 0:
			rem_extra_jumps -= 1
		else:
			return
	
	var impulse: Vector2 = -Vector2(0, linear_velocity.y) + Vector2.UP * JUMP_FORCE
	apply_central_impulse(impulse)
	jump_cd_ready = false
	jump_cd.start(JUMP_CD_LENGTH)


func die():
	hide()
	set_deferred("freeze", true)
	disable_input()
	GameState.camera.freeze()
	UILayer.show_death_screen()


func revive():
	show()
	set_deferred("freeze", false)


func _on_body_entered(_body):
	# TODO: Calculate this according to collision vectors instead
	var shake_strength: float = 0.0003 * linear_velocity.length()
	GameState.shake_camera(shake_strength)


func _on_jump_cd_timeout():
	jump_cd_ready = true


func _on_floor_grace_timer_timeout():
	floor_grace_ready = true
