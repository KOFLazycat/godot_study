extends Node2D

@onready var texture_progress_bar = $TextureProgressBar
@onready var timer = $Timer


var hp_value = 100
var hp_speed = -10

# Called when the node enters the scene tree for the first time.
func _ready():
	texture_progress_bar.min_value = 0
	texture_progress_bar.max_value = 100
	texture_progress_bar.value = hp_value
	timer.start(0.4)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	hp_value = hp_value + hp_speed
	var tween = create_tween()
	tween.tween_property(texture_progress_bar,"value",hp_value, 0.1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.play()
#	texture_progress_bar.value = hp_value
	if hp_value <= 0 or hp_value >= 100:
		hp_speed = hp_speed*(-1)
