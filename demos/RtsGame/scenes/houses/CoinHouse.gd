extends StaticBody2D

var Pop = preload("res://global/Pop.tscn")
@onready var progress_bar = $ProgressBar
@onready var timer = $Timer
var totalTime:int = 50
var currentTime:int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	currentTime = totalTime
	progress_bar.max_value = totalTime
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if currentTime <= 0:
		coinsCollected()


func _on_timer_timeout():
	currentTime -= 1
	var tween = get_tree().create_tween()
	tween.tween_property(progress_bar, "value", currentTime, 0.1).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN_OUT)


func coinsCollected():
	Game.Coin += 10
	_ready()
	var pop = Pop.instantiate()
	add_child(pop)
	pop.show_value(str(10), false)
