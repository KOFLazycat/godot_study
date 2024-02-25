extends Control

@export var stats: Stats

@onready var health_bar: TextureProgressBar = $HB/HealthBar
@onready var eased_health_bar: TextureProgressBar = $HB/HealthBar/EasedHealthBar


func _ready() -> void:
	stats.health_changed.connect(on_health_changed)


func update_health() -> void:
	var percentage: float = stats.health / float(stats.max_health)
	health_bar.value = percentage
	
	var tween: Tween = create_tween()
	tween.tween_property(eased_health_bar, "value", percentage, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)


func on_health_changed() -> void:
	update_health()
