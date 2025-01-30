class_name Enemy
extends Area2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var explodable: Explodable = $Explodable

@export var sprites: Array[EnemySprites]
var curr_sprites: EnemySprites

const ANIM_SPEED: float = 10
var frame_timer: float = 0

var dead: bool = false


func _ready():
	curr_sprites = sprites.pick_random()
	sprite.texture = curr_sprites.sheet
	sprite.hframes = curr_sprites.frame_count
	
	explodable.textures = curr_sprites.part_sprites
	explodable.piece_count = curr_sprites.part_sprites.size()


func _process(delta):
	animate(delta)


func animate(delta):
	frame_timer += delta
	if frame_timer >= 1 / ANIM_SPEED:
		frame_timer = 0
		sprite.frame = (sprite.frame + 1) % sprite.hframes


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
