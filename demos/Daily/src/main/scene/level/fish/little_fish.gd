extends Node2D

@onready var timer = $Timer


var target = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	scale = Vector2(0.5, 0.5)
	position = Vector2(randi_range(60, 900), randi_range(20, 700))
	timer.start(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(target)
	position = lerp(position, target, 0.02)


func _on_timer_timeout():
	target = Vector2(randi_range(60, 900), randi_range(20, 700))


func _on_area_2d_area_entered(area):
	if area.is_in_group("big_fish"):
		queue_free()
