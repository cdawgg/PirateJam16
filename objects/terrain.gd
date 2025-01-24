@tool
class_name Terrain
extends StaticBody2D

var shape: CollisionShape2D
var sprite: Sprite2D

@export var texture: Texture2D

func _ready():
	shape = get_node_or_null("CollisionShape2D")
	sprite = get_node_or_null("Sprite2D")


func _process(_delta):
	if sprite && shape:
		sprite.region_enabled = true
		sprite.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
		sprite.texture = texture
		sprite.position = shape.position
		sprite.region_rect = Rect2(Vector2.ZERO, shape.shape.size)

#TODO get from shootable
