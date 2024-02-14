extends Node

const SOUND_MAIN_MENU = "main"
const SOUND_IN_GAME = "ingame"
const SOUND_SUCCESS = "success"
const SOUND_GAME_OVER = "gameover"
const SOUND_SELECT_TILE = "tile"
const SOUND_SELECT_BUTTON = "button"

const SOUNDS = {
	SOUND_MAIN_MENU: preload("res://src/main/assets/sounds/bgm_action_3.mp3"),
	SOUND_IN_GAME: preload("res://src/main/assets/sounds/bgm_action_4.mp3"),
	SOUND_SUCCESS: preload("res://src/main/assets/sounds/sfx_sounds_fanfare3.wav"),
	SOUND_GAME_OVER: preload("res://src/main/assets/sounds/sfx_sounds_powerup12.wav"),
	SOUND_SELECT_TILE: preload("res://src/main/assets/sounds/sfx_sounds_impact1.wav"),
	SOUND_SELECT_BUTTON: preload("res://src/main/assets/sounds/sfx_sounds_impact7.wav")
}


func play_sound(player: AudioStreamPlayer, key: String, random: bool) -> void:
	if SOUNDS.has(key) == false:
		return
		
	player.stop()
	player.stream = SOUNDS[key]
	# 备份随机前的声音数
	var volume_db: float = player.volume_db
	var pitch_scale: float = player.pitch_scale
	if random == true:
		# 临时随机一下声音
		player.volume_db = player.volume_db + randf_range(-5.0, 5.0)
		player.pitch_scale = player.pitch_scale + randf_range(-0.2, 0.2)
	player.play()
	await player.finished
	player.volume_db = volume_db
	player.pitch_scale = pitch_scale


func play_button_click(player: AudioStreamPlayer, random: bool) -> void:
	play_sound(player, SOUND_SELECT_BUTTON, random)


func play_tile_click(player: AudioStreamPlayer, random: bool) -> void:
	play_sound(player, SOUND_SELECT_TILE, random)
