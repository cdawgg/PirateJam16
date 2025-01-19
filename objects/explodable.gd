class_name Explodable
extends Node2D

@export var textures: Array[Texture2D]
@export var piece_count: int

@onready var parent: Node = get_parent()
@onready var piece_packed: PackedScene = preload('res://objects/explodable_piece.tscn')
var pieces: Array[ExplodablePiece] = []


func _ready():
	if !piece_count: piece_count = textures.size()
	if parent is CanvasItem: parent.visibility_changed.connect(explode)
	GameState.level_started.connect(end_pieces)


func explode():
	if parent.visible: return
	
	for i in piece_count:
		var piece: ExplodablePiece = piece_packed.instantiate()
		var looped_index: int = i % textures.size()
		
		piece.set_texture(textures[looped_index])
		GameState.game_world.call_deferred("add_child", piece)
		piece.global_position = parent.global_position
		
		var parent_velocity: Vector2 = Vector2.ZERO
		if parent is Boulder:
			parent_velocity = parent.linear_velocity
		
		piece.launch(parent_velocity)
		pieces.append(piece)


func end_pieces():
	if !pieces: return
	
	for piece in pieces:
		if !is_instance_valid(piece): continue
		piece.end()
	
	pieces = []
