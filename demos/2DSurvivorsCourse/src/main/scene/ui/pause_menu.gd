extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var panel_container: PanelContainer = $MarginContainer/PanelContainer
@onready var resume_button: Button = %ResumeButton
@onready var options_button: Button = %OptionsButton
@onready var quit_button: Button = %QuitButton

var options_menu_scene = preload("res://src/main/scene/ui/options_menu.tscn") as PackedScene
var is_closing: bool = false


func _ready() -> void:
	get_tree().paused = true
	panel_container.pivot_offset = panel_container.size/2
	resume_button.pressed.connect(on_resume_pressed)
	options_button.pressed.connect(on_options_pressed)
	quit_button.pressed.connect(on_quit_pressed)
	animation_player.play("default")
	
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		close()
		get_tree().root.set_input_as_handled()


func close() -> void:
	if is_closing:
		return
	is_closing = true
	animation_player.play_backwards("default")
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0)
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	get_tree().paused = false
	queue_free()


func on_resume_pressed() -> void:
	close()


func on_options_pressed() -> void:
	ScreenTransition.transition()
	#await ScreenTransition.transition_halfway
	await ScreenTransition.animation_player.animation_finished
	var options_menu_instance = options_menu_scene.instantiate()
	add_child(options_menu_instance)


func on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://src/main/scene/ui/main_menu.tscn")
