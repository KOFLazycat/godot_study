extends Node

@onready var sfx: Node = $SFX
@onready var bgm_player: AudioStreamPlayer = $BGMPlayer

enum Bus {MASTER, SFX, BGM}


func play_sfx(name: String) -> void:
	var player := sfx.get_node(name) as AudioStreamPlayer
	if not player:
		return
	player.play()


func play_bgm(stream: AudioStream) -> void:
	if bgm_player.stream == stream and bgm_player.playing:
		return
	bgm_player.stream = stream
	bgm_player.play()


func setup_ui_sounds(node: Node) -> void:
	var button := node as Button
	if button:
		print(button)
		button.pressed.connect(play_sfx.bind("UIPress"))
		button.focus_entered.connect(play_sfx.bind("UIFocus"))
	
	for c in node.get_children():
			setup_ui_sounds(c)


func get_volume(bus_index: int) -> float:
	var db := AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(db)


func set_volume(bus_index: int, v: float) -> void:
	var db := linear_to_db(v)
	AudioServer.set_bus_volume_db(bus_index, db)
