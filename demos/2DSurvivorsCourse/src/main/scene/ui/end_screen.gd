extends CanvasLayer

@onready var continue_button: Button = %ContinueButton
@onready var quit_button: Button = %QuitButton
@onready var title_label: Label = %TitleLabel
@onready var description_label: Label = %DescriptionLabel
@onready var panel_container: PanelContainer = %PanelContainer
@onready var victory_random_stream_player_component: AudioStreamPlayer = $VictoryRandomStreamPlayerComponent
@onready var defeat_random_stream_player_component: AudioStreamPlayer = $DefeatRandomStreamPlayerComponent


func _ready() -> void:
	panel_container.pivot_offset = panel_container.size / 2
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	get_tree().paused = true
	continue_button.pressed.connect(on_continue_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)


func set_defeat() -> void:
	play_jingle(true)
	title_label.text = "Defeat"
	description_label.text = "You Lost!"


func play_jingle(defeat: bool = false) -> void:
	if defeat:
		defeat_random_stream_player_component.play_random()
	else:
		victory_random_stream_player_component.play_random()


func on_continue_button_pressed() -> void:
	get_tree().paused = false
	ScreenTransition.transition_to_scene("res://src/main/scene/ui/meta_menu.tscn")


func on_quit_button_pressed() -> void:
	MetaProgression.save_file()
	ScreenTransition.transition_to_scene("res://src/main/scene/ui/main_menu.tscn")
	get_tree().paused = false
