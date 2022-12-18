extends Area2D


func _init():
	# The hurtbox should detect hits but not deal them. This variable does that.
	monitorable = false
	# This turns off collision layer bit 1 and turns on bit 2. It's the physics layer we reserve to hurtboxes in this demo.
	collision_mask = 2


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))


func _on_area_entered(area):
	if owner.has_method("take_damage"):
		owner.take_damage(area.damage)
