class_name Stats
extends Node

@export var max_health: int = 3
@export var max_energy: float = 10.0
@export var energy_regen: float = 0.5

@onready var health: int = max_health:
	set(v):
		v = clampi(v, 0, max_health)
		if health == v:
			return
		health = v
		health_changed.emit()

@onready var energy: float = max_energy:
	set(v):
		v = clampf(v, 0.0, max_energy)
		if energy == v:
			return
		energy = v
		energy_changed.emit()

signal health_changed
signal energy_changed


func _process(delta: float) -> void:
	# 自动恢复能量
	energy += energy_regen * delta


func to_dict() -> Dictionary:
	return {
		"max_energy": max_energy,
		"max_health": max_health,
		"health": health,
	}


func from_dict(dict: Dictionary) -> void:
	max_energy = dict.max_energy
	## 注意max_health和health的设置顺序，health要受到max_health的制约，所以需要先设置max_health
	max_health = dict.max_health
	health = dict.health
