extends CanvasLayer

@onready var label = $Label


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	label.text = "Wood: " + str(Game.Wood)
