extends Node2D


var flag = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_up_area_entered(area: Area2D) -> void:
	if area.is_in_group("ball"):
		flag = true
		Global.glob_score += 1
		get_parent().get_node("GPUParticles2D").position = position
		get_parent().get_node("GPUParticles2D").emitting = true
		get_parent().get_node("AudioStreamPlayer2D").playing = true
		queue_free()
		
