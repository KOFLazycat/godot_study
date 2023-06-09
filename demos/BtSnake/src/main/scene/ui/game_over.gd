extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Score.text = "Total Score: %d" % Global.get_total_score()
	$Bonus.text = "Bonus Score: %d" % Global.get_total_bonus()
	$SnakeLength.text = "Snake Length: %d" % (Global.get_total_score() - Global.get_total_bonus() + 1)
	$Difficulty.text = "Difficulty: " + ("HARD" if Global.difficulty == Global.Difficulty.HARD else "NORMAL")


func _on_button_pressed() -> void:
	# Remove the current game scene.
	get_tree().current_scene.free()
	# Attach the game screen to the root node, making it visible.
	get_tree().change_scene_to_file("res://src/main/scene/ui/start.tscn")
	# Remove the game over screen
	queue_free()
