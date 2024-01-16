extends ParallaxBackground

const SPEED: float = 120.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.game_over.connect(on_game_over)


func _process(delta: float) -> void:
	scroll_offset.x += SPEED * delta * -1


func on_game_over() -> void:
	set_process(false)
