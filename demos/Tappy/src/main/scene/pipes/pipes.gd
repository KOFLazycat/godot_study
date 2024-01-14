extends Node2D

@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

const SCROLL_SPEED: float = 80.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible_on_screen_notifier_2d.screen_exited.connect(on_visible_on_screen_notifier_2d_screen_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x -= SCROLL_SPEED * delta


func on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
