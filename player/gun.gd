class_name Gun
extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var fire_point: Marker2D = $FirePoint
@onready var timer: Timer = $Timer
@onready var bullet_packed: PackedScene = preload("res://player/bullet.tscn")

const COOLDOWN: float = 1
var on_cooldown: bool = false


func _ready():
	timer.timeout.connect(_on_timer_timeout)


func fire():
	if on_cooldown: return
	
	look_at(get_global_mouse_position())
	var bullet: Bullet = bullet_packed.instantiate()
	GameState.game_world.add_child(bullet)
	bullet.global_position = fire_point.global_position
	bullet.fire(get_global_mouse_position(), get_parent().linear_velocity)
	
	on_cooldown = true
	timer.start(COOLDOWN)


func _on_timer_timeout():
	timer.stop()
	on_cooldown = false
