class_name Enemy
extends Area2D

const TEXTURES: Array[Texture2D] = [
	preload("res://assets/sprites/enemy1.png"),
	preload("res://assets/sprites/enemy2.png"),
	preload("res://assets/sprites/enemy3.png"),
	preload("res://assets/sprites/enemy4.png")
]

var dead: bool = false


func _ready():
	$Sprite2D.texture = TEXTURES.pick_random()


func die():
	hide()
	dead = true
	set_deferred("process_mode", PROCESS_MODE_DISABLED)
	
	GameState.level_kill_count += 1
	GameState.shake_camera(0.5)


func respawn():
	show()
	dead = false
	process_mode = PROCESS_MODE_INHERIT


func _on_body_entered(body):
	if body is Boulder:
		die()
