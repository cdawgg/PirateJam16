class_name Bullet
extends RigidBody2D

const FORCE: float = 4000
const MAX_LIFETIME: float = 5

var lifetime: float


func _physics_process(delta):
	if lifetime <= 0: remove()
	lifetime -= delta


func fire(target: Vector2, parent_velocity: Vector2):
	var dir: Vector2 = (target - global_position).normalized()
	linear_velocity = parent_velocity + (dir * FORCE)
	lifetime = MAX_LIFETIME
	look_at(target)


func remove():
	hide()
	queue_free()


func _on_hitbox_area_entered(area):
	if area is Enemy:
		area.die()
	elif area is Shootable:
		area.hit()
	remove()


func _on_hitbox_body_entered(body):
	remove()
