extends Path2D


@onready var path_follow_2d: PathFollow2D = $PathFollow2D

@export var speed:int = 50


func _physics_process(delta: float) -> void:
	path_follow_2d.set_progress(path_follow_2d.get_progress() + speed * delta)
	if path_follow_2d.get_progress_ratio() == 1:
		queue_free()


func _on_enemy_mouse_enemy_die():
	queue_free()
