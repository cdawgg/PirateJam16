class_name Camera
extends Camera2D

# Shake parameters
const MAX_SHAKE_STRENGTH: Vector2 = Vector2(25, 25)
const MIN_SHAKE_DURATION: float = 0.1
const MAX_SHAKE_DURATION: float = 0.7

var shake_timer: float = 0
var shaking: bool = false
var curr_strength: float = 0

@export var base_offset: Vector2


func _ready():
	base_offset = offset


func _process(delta):
	if shaking:
		shake_timer -= delta
		if shake_timer <= 0:
			shaking = false
			offset = base_offset
			rotation = 0
		else:
			var decay_factor = shake_timer / get_scaled_shake_duration()
			
			var scaled_strength = MAX_SHAKE_STRENGTH * curr_strength * decay_factor
			
			offset = base_offset + Vector2(
				randf_range(-scaled_strength.x, scaled_strength.x),
				randf_range(-scaled_strength.y, scaled_strength.y)
			)


func shake(strength: float = 0.5):
	shaking = true
	shake_timer = get_scaled_shake_duration()
	curr_strength = clamp(strength, 0, 1)


func get_scaled_shake_duration() -> float:
	return lerp(MIN_SHAKE_DURATION, MAX_SHAKE_DURATION, curr_strength)
