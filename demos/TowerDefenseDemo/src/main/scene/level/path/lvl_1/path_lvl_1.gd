extends Path2D

@onready var path_follow_2d: PathFollow2D = $PathFollow2D

@export var speed:int = 100


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	path_follow_2d.set_progress(path_follow_2d.get_progress() + speed * delta)
	if path_follow_2d.get_progress_ratio() == 1:
		queue_free()


func _on_soldier_enemy_die() -> void:
	queue_free()
