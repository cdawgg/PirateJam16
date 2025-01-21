@tool
class_name DeathZone
extends Area2D

@onready var shape: CollisionShape2D = $CollisionShape2D


func _ready():
	shape.shape = shape.shape.duplicate()


func _on_body_entered(body):
	if body is Boulder:
		body.die()
