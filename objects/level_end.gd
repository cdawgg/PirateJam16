class_name LevelEnd
extends Area2D

@onready var guy: Area2D = $Guy
@onready var guy_sprite: Sprite2D = $Guy/Sprite2D

var locked_in: bool = false
const LOCK_IN_FORCE: float = 5000

var wait_timer: Timer
const WAIT_TIME: float = 2


func _ready():
	wait_timer = Timer.new()
	add_child(wait_timer)


func _physics_process(delta):
	if locked_in:
		var dir: Vector2 = guy.global_position - GameState.boulder.global_position
		GameState.boulder.apply_central_force(dir * LOCK_IN_FORCE * delta)


func _on_body_entered(body):
	if body is Boulder:
		GameState.camera.set_follow_target(guy_sprite)
		locked_in = true


func _on_guy_body_entered(body):
	if body is Boulder:
		body.disable_input()
		guy.hide()
		GameState.level.timer.stop()
		locked_in = false
		wait_timer.start(WAIT_TIME)
		await wait_timer.timeout
		
		UILayer.show_level_end_screen()
