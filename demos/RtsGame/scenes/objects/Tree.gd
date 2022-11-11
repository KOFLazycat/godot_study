extends StaticBody2D

var totalTime:int = 5
var currentTime:int = 0
var unitsCount:int = 0
@onready var progress_bar = $ProgressBar
@onready var timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	progress_bar.max_value = totalTime
	currentTime = totalTime


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#progress_bar.value = currentTime
	if currentTime <= 0:
		treeChopped()


func _on_crop_area_body_entered(body):
	# print(body.name)
	if "Unit" in body.name:
		unitsCount += 1
		startChopping()


func _on_crop_area_body_exited(body):
	if "Unit" in body.name:
		unitsCount -= 1
		if unitsCount <= 0:
			timer.stop()


func _on_timer_timeout():
	currentTime -= 1*unitsCount
	var tween = get_tree().create_tween()
	tween.tween_property(progress_bar, "value", currentTime, 0.5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN_OUT)


# 开始伐木
func startChopping():
	timer.start()


# 树被砍完
func treeChopped():
	Game.Wood += 1
	queue_free()
