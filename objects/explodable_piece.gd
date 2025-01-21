class_name ExplodablePiece
extends RigidBody2D

const LIN_FORCE: float = 700
const ROT_FORCE: float = 5
const LIFETIME: float = 5
const FADE_THRESHOLD: float = 1

var curr_lifetime: float = LIFETIME


func _physics_process(delta):
	if curr_lifetime <= 0:
		end()
		return
	
	if curr_lifetime <= FADE_THRESHOLD:
		modulate.a = curr_lifetime / FADE_THRESHOLD
	
	curr_lifetime -= delta


func set_texture(texture: Texture2D):
	$Sprite2D.texture = texture


func launch(parent_velocity: Vector2):
	var dir: Vector2 = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	linear_velocity = (parent_velocity.normalized() + dir) * LIN_FORCE
	angular_velocity = randf_range(-1, 1) * ROT_FORCE
	show()


func end():
	hide()
	queue_free()
