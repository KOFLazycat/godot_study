extends Control

@export var stats: Stats

@onready var health_bar: TextureProgressBar = $HB/VB/HealthBar
@onready var eased_health_bar: TextureProgressBar = $HB/VB/HealthBar/EasedHealthBar
@onready var energy_bar: TextureProgressBar = $HB/VB/EnergyBar
@onready var eased_energy_bar: TextureProgressBar = $HB/VB/EnergyBar/EasedEnergyBar


func _ready() -> void:
	stats.health_changed.connect(on_health_changed)
	stats.energy_changed.connect(on_energy_changed)
	update_health()
	update_energy()


func update_health() -> void:
	var percentage: float = stats.health / float(stats.max_health)
	health_bar.value = percentage
	
	var tween: Tween = create_tween()
	tween.tween_property(eased_health_bar, "value", percentage, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)


func update_energy() -> void:
	var percentage: float = stats.energy / stats.max_energy
	energy_bar.value = percentage
	
	var tween: Tween = create_tween()
	tween.tween_property(eased_energy_bar, "value", percentage, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)


func on_health_changed() -> void:
	update_health()


func on_energy_changed() -> void:
	update_energy()
