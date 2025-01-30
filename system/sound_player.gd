extends Node

const SFX_MAX_DISTANCE: float = 2000

@onready var audio_players = $AudioPlayers
@onready var audio_players_2D = $AudioPlayers2D
@onready var music_player: AudioStreamPlayer = $MusicPlayer

var music_position: float = 0


func play_sound(sound: AudioStream, volume: float = 0) -> AudioStreamPlayer:
	for audio_player in audio_players.get_children():
		if audio_player.playing: continue
		
		reset_sfx_player(audio_player)
		audio_player.stream = sound
		audio_player.volume_db = volume
		audio_player.play()
		return audio_player
	
	return null


func play_sound2D(sound: AudioStream, pos: Vector2, volume: float = 0) -> AudioStreamPlayer2D:
	for audio_player in audio_players_2D.get_children():
		if audio_player.playing: continue ;
		
		reset_sfx_player(audio_player)
		audio_player.stream = sound
		audio_player.volume_db = volume
		audio_player.position = pos
		audio_player.play()
		return audio_player
		
	return null


func play_music(music: AudioStream, volume: float = 0):
	if !is_node_ready(): await ready
	
	if music_player.playing:
		# Return if track is already playing, or no new music is called
		if music_player.stream == music || !music: return
	
	music_player.stream = music
	music_player.volume_db = volume
	music_player.play()


func fade_music(target_volume: float, duration: float, fade_in: bool = false):
	target_volume = clamp(target_volume, 0.0, 1.0)
	var target_volume_db: float
	if target_volume == 0:
		target_volume_db = -80
	else:
		target_volume_db = linear_to_db(target_volume)
	if fade_in: music_player.volume_db = -20
	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", target_volume_db, duration).from_current()
	await tween.finished


func pause_music(val: bool):
	if val:
		music_position = music_player.get_playback_position()
		music_player.stop()
	else:
		music_player.play(music_position)


func stop_music():
	music_player.stop()
	music_player.stream = null


func reset_sfx_player(sfx_player):
	sfx_player.stop()
	sfx_player.bus = 'SFX'
	sfx_player.pitch_scale = 1
	
	if sfx_player is AudioStreamPlayer2D:
		sfx_player.max_distance = SFX_MAX_DISTANCE


func stop_all_sfx():
	for audio_player in audio_players.get_children():
		reset_sfx_player(audio_player)
	for audio_player in audio_players_2D.get_children():
		reset_sfx_player(audio_player)
