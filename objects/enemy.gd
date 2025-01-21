class_name Enemy
extends Area2D

@onready var explodable: Explodable = $Explodable

@export var sprites: Array[EnemySprites]
var curr_sprites: EnemySprites

var dead: bool = false


func _ready():
	curr_sprites = sprites.pick_random()
	$Sprite2D.texture = curr_sprites.full_sprite
	explodable.textures = curr_sprites.part_sprites
	explodable.piece_count = curr_sprites.part_sprites.size()


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
