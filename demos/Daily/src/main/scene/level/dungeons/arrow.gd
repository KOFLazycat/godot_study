extends Area2D

var dir: Vector2 = Vector2.ZERO
const SPEED: float = 300.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.position += dir * SPEED * delta


func shot(_dir, _pos) -> void:
	dir = _dir
	self.position = _pos
	self.rotation = dir.angle()


func _on_body_entered(_body: Node2D) -> void:
	self.queue_free()
