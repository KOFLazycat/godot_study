extends Control

@export var mem_tile_scene: PackedScene

@onready var exit_button: TextureButton = $HB/MC2/VB/ExitButton
@onready var sound: AudioStreamPlayer = $Sound
@onready var tile_container: GridContainer = $HB/MC1/TileContainer
@onready var scorer: Scorer = $Scorer
@onready var moves_label: Label = $HB/MC2/VB/HB/MovesLabel
@onready var pairs_label: Label = $HB/MC2/VB/HB2/PairsLabel


func _ready() -> void:
	exit_button.pressed.connect(on_exit_button_pressed)
	SignalManager.level_selected.connect(on_level_selected)


func _process(delta: float) -> void:
	moves_label.text = scorer.get_moves_made_str()
	pairs_label.text = scorer.get_pairs_made_str()


func add_memory_tile(ii_dict: Dictionary, frame_image: CompressedTexture2D) -> void:
	var mem_tile = mem_tile_scene.instantiate()
	tile_container.add_child(mem_tile)
	mem_tile.setup(ii_dict, frame_image)


func on_exit_button_pressed() -> void:
	SoundManager.play_button_click(sound, true)
	SignalManager.game_exit_pressed.emit()


func on_level_selected( level_num: int) -> void:
	var level_selection = GameManager.get_level_selection(level_num)
	var frame_image = ImageManager.get_random_frame_image()
	
	tile_container.columns = level_selection.num_cols
	
	for ii_dict in level_selection.image_list:
		add_memory_tile(ii_dict, frame_image)
	
	scorer.clear_new_game(level_selection.target_pairs)
