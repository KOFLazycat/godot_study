extends Sprite2D

@onready var marker_2d: Marker2D = $Marker2D

var dir: Vector2 = Vector2.ZERO
var fire_pos: Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	dir = (get_global_mouse_position() - self.global_position).normalized()
	self.rotation = dir.angle()
	fire_pos = marker_2d.global_position
