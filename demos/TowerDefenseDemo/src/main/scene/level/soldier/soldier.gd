extends CharacterBody2D

@onready var blood: Node2D = $Blood
@onready var sprite_2d: Sprite2D = $Sprite2D

signal enemy_die

var blood_offset_y = -35

func _physics_process(_delta: float) -> void:
	blood.global_position.x = sprite_2d.global_position.x
	blood.global_position.y = sprite_2d.global_position.y + blood_offset_y
	blood.global_rotation_degrees = 0


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("missile"):
		blood.value_change(area.get_parent().missile_damage)
		if blood.blood_value <= 0:
			emit_signal("enemy_die")
