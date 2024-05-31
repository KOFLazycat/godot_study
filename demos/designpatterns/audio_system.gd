extends Node

@export var musics: Array[AudioStreamMP3]
@export var sfxs: Array[AudioStreamWAV]

@onready var bgm_audio_stream_player_2d: AudioStreamPlayer2D = $BGMAudioStreamPlayer2D
@onready var sfx_audio_stream_player_2d: AudioStreamPlayer2D = $SFXAudioStreamPlayer2D


## 播放指定索引的音乐
func play_bgm(bgm_index: int) -> void:
	if bgm_audio_stream_player_2d.playing:
		var tween: Tween = create_tween()
		tween.tween_property(bgm_audio_stream_player_2d, "volume_db", -60, 0.5)
		await tween.finished
		bgm_audio_stream_player_2d.stop()
	bgm_audio_stream_player_2d.bus = "BGM"
	bgm_audio_stream_player_2d.stream = musics[bgm_index]
	bgm_audio_stream_player_2d.play()
	
	var tween: Tween = create_tween()
	tween.tween_property(bgm_audio_stream_player_2d, "volume_db", 0, 0.5) 


func play_sfx(sfx_index: int) -> void:
	if sfx_audio_stream_player_2d.playing:
		var new_sfx_audio_stream_player_2d: AudioStreamPlayer2D = sfx_audio_stream_player_2d.duplicate() as AudioStreamPlayer2D
		new_sfx_audio_stream_player_2d.finished.connect(on_sfx_finished.bind(new_sfx_audio_stream_player_2d))
		new_sfx_audio_stream_player_2d.stream = sfxs[sfx_index]
		add_child(new_sfx_audio_stream_player_2d)
		new_sfx_audio_stream_player_2d.bus = "SFX"
		new_sfx_audio_stream_player_2d.play()
	else:
		sfx_audio_stream_player_2d.stream = sfxs[sfx_index]
		sfx_audio_stream_player_2d.bus = "SFX"
		sfx_audio_stream_player_2d.play()
		


func on_sfx_finished(sfx_audio_stream: AudioStreamPlayer2D) -> void:
	sfx_audio_stream.queue_free()

















