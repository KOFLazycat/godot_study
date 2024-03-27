class_name Blood
extends ProgressBar

@onready var blood_under: ProgressBar = $BloodUnder

var health: float = 0.0: set = set_health
var health_tween: Tween


func set_health(new_health_v: float) -> void:
	var pre_health_v: float = health
	health = clamp(new_health_v, 0, max_value)
	
	health_tween = get_tree().create_tween()
	health_tween.tween_property(self, "value", health, 0.1).set_trans(Tween.TRANS_LINEAR)
	
	if blood_under.value > health:
		health_tween.tween_property(blood_under, "value", health, 0.4).set_trans(Tween.TRANS_LINEAR)
	
	await health_tween.finished
	
	if health <= 0:
		queue_free()


func init_health(health_v: float) -> void:
	health = health_v
	max_value = health
	value = health
	blood_under.max_value = health
	blood_under.value = health
	
	
	
