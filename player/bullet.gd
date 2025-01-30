class_name Bullet
extends RigidBody2D

const FORCE: float = 3000
const MAX_LIFETIME: float = 5
const RAY_LENGTH: float = 400

@onready var ray: RayCast2D = $RayCast2D
var ray_target: Object

var orig_pos: Vector2
var ray_tar_pos: Vector2
var dir: Vector2
var lifetime: float

@onready var shoot_sound: AudioStreamPlayer2D = $ShootSound
@onready var explode_sound: AudioStreamPlayer2D = $ExplodeSound


func _process(delta):
	if !visible: return
	
	if !ray_target:
		ray_target = ray.get_collider()
		if ray_target is Area2D:
			ray_tar_pos = ray.get_collision_point()
	elif ray_tar_pos:
		var curr_prog: float = global_position.rotated(-global_position.angle()).x
		var tar_prog: float = ray_tar_pos.rotated(-ray_tar_pos.angle()).x

		# If bullet has moved past its raycasted target
		if tar_prog - curr_prog >= 0:
			_on_hitbox_area_entered(ray_target)
	
	if lifetime <= 0: remove()
	lifetime -= delta


func fire(target: Vector2, parent_velocity: Vector2):
	dir = (target - global_position).normalized()
	ray.target_position = Vector2(RAY_LENGTH, 0)
	linear_velocity = parent_velocity + (dir * FORCE)
	lifetime = MAX_LIFETIME
	look_at(target)
	shoot_sound.play()


func remove():
	explode_sound.play()
	$Hitbox.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	hide()


func _on_hitbox_area_entered(area):
	if area is Enemy:
		area.die()
	elif area is Shootable:
		area.hit()
	remove()


func _on_hitbox_body_entered(body):
	remove()
