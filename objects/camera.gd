class_name Camera
extends Camera2D

# Shake parameters
const MAX_SHAKE_STRENGTH: Vector2 = Vector2(25, 25)
const MIN_SHAKE_DURATION: float = 0.1
const MAX_SHAKE_DURATION: float = 0.7

var shake_timer: float = 0
var shaking: bool = false
var curr_strength: float = 0

const BASE_OFFSET: Vector2 = Vector2(100, 50)
const SMOOTHING: float = 5

var is_lerping: bool = false
var target_offset: Vector2 = Vector2.ZERO
var follow_target: Node2D


func _physics_process(delta):
	if follow_target:
		var target_position = follow_target.global_position - target_offset
		
		if is_lerping:
			# Ease towards the target
			position = position.lerp(target_position, SMOOTHING * delta)
			
			if position.distance_to(target_position) < 0.1:
				position = target_position
				is_lerping = false
		else:
			position = target_position # Follow the target directly after reaching it the first time
	
	if shaking:
		shake_timer -= delta
		if shake_timer <= 0:
			shaking = false
			rotation = 0
		else:
			var decay_factor = shake_timer / get_scaled_shake_duration()
			
			var scaled_strength = MAX_SHAKE_STRENGTH * curr_strength * decay_factor
			
			offset = Vector2(
				randf_range(-scaled_strength.x, scaled_strength.x),
				randf_range(-scaled_strength.y, scaled_strength.y)
			)


func set_follow_target(target: Node2D):
	follow_target = target
	var target_position: Vector2 = follow_target.global_position
	var skip_lerping: bool = false
	
	if target is Boulder:
		target_position += BASE_OFFSET
		skip_lerping = true
	
	pan_to_target(target_position, skip_lerping)


func pan_to_target(target_position: Vector2, skip_lerping: bool = false):
	target_offset = follow_target.global_position - target_position
	is_lerping = !skip_lerping


func shake(strength: float = 0.5):
	shaking = true
	shake_timer = get_scaled_shake_duration()
	curr_strength = clamp(strength, 0, 1)


func get_scaled_shake_duration() -> float:
	return lerp(MIN_SHAKE_DURATION, MAX_SHAKE_DURATION, curr_strength)


func freeze():
	var old_pos: Vector2 = global_position
	reparent(GameState.game_world)
	global_position = old_pos
