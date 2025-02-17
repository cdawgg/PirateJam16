class_name Boulder
extends RigidBody2D

const MAX_SPEED: float = 1000
const JUMP_FORCE: float = 400
const ACCEL_FORCE: float = 300
const TORQUE_FORCE: float = 200

@onready var gun: Gun = $Gun

var input_disabled: bool = true
var horizontal_input: float = 0

var on_floor: bool = false
var floor_grace_timer: Timer
var floor_grace_ready: bool = true
const FLOOR_GRACE_PERIOD: float = 0.2

var extra_jumps: int = 0
var rem_extra_jumps: int = extra_jumps
var jump_cd: Timer
var jump_cd_ready: bool = true
const JUMP_CD_LENGTH: float = 0.3

const MAX_RUMBLE_VOLUME: float = 1
const MAX_BOUNCE_VOLUME: float = 3.5
@onready var rumble_sound: AudioStreamPlayer2D = $RumbleSound
@export var bounce_sounds: Array[AudioStream]
@export var jump_sound: AudioStream
@export var death_sound: AudioStream

const COLLISION_THRESHOLD: float = 5


func _ready():
	jump_cd = Timer.new()
	jump_cd.timeout.connect(_on_jump_cd_timeout)
	add_child(jump_cd)
	
	floor_grace_timer = Timer.new()
	floor_grace_timer.timeout.connect(_on_floor_grace_timer_timeout)
	add_child(floor_grace_timer)
	
	rumble_sound.play()


func _input(event):
	if event.is_action_pressed("restart"): #restart set to R
		GameState.restart_level()
	
	if input_disabled: return
	
	if event.is_action_pressed("jump"): #jump set to space bar
		jump()
		
	if event.is_action_pressed("fire_gun"):
		gun.fire()
		

func _physics_process(delta):
	horizontal_input = 0
	if !input_disabled:
		if Input.is_action_pressed("accelerate"):
			horizontal_input += 1
			$Sprite2D.rotation += 5 * delta
		if Input.is_action_pressed("decelerate"):
			horizontal_input -= 1
			$Sprite2D.rotation -= 5 * delta
	
	apply_central_force(Vector2(horizontal_input * ACCEL_FORCE, 0))
	
	if abs(linear_velocity.x) > MAX_SPEED:
		linear_velocity.x = clamp(linear_velocity.x, -MAX_SPEED, MAX_SPEED)
	
	apply_torque(linear_velocity.x * TORQUE_FORCE * delta)
	
	scale_rumble_volume()


func _integrate_forces(state: PhysicsDirectBodyState2D):
	on_floor = check_on_floor(state)


func scale_rumble_volume():
	var speed_ratio = abs(linear_velocity.x) / MAX_SPEED
	speed_ratio = clamp(speed_ratio, 0.25, 1)
	
	var target_volume = speed_ratio * MAX_RUMBLE_VOLUME
	if !on_floor || !input_disabled && horizontal_input == 0: target_volume = 0
	
	var target_volume_db = linear_to_db(target_volume)
	rumble_sound.volume_db = target_volume_db


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


func jump():
	if !jump_cd_ready: return
	
	if !on_floor:
		if rem_extra_jumps > 0:
			rem_extra_jumps -= 1
		else:
			return
	
	var impulse: Vector2 = -Vector2(0, linear_velocity.y) + Vector2.UP * JUMP_FORCE
	SoundPlayer.play_sound2D(jump_sound, global_position)
	apply_central_impulse(impulse)
	jump_cd_ready = false
	jump_cd.start(JUMP_CD_LENGTH)


func die():
	hide()
	set_deferred("freeze", true)
	disable_input()
	GameState.camera.freeze()
	GameState.level.timer.stop()
	SoundPlayer.play_sound(death_sound)
	UILayer.show_death_screen()


func revive():
	show()
	set_deferred("freeze", false)


func _on_body_entered(body):
	var normal = PhysicsServer2D.body_get_direct_state(get_rid()).get_contact_local_normal(0)
	var impulse = linear_velocity.dot(normal)
	if abs(impulse) > COLLISION_THRESHOLD:
		var max_impulse = COLLISION_THRESHOLD * 80
		var impulse_ratio = impulse / max_impulse
		impulse_ratio = clamp(impulse_ratio, 0.2, 1)
		
		var shake_strength: float = impulse_ratio * 0.7
		GameState.shake_camera(shake_strength)
		
		var volume_db = linear_to_db(impulse_ratio * MAX_BOUNCE_VOLUME)
		SoundPlayer.play_sound2D(bounce_sounds.pick_random(), global_position, volume_db)


func _on_jump_cd_timeout():
	jump_cd_ready = true


func _on_floor_grace_timer_timeout():
	floor_grace_ready = true
