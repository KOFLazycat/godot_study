extends Command
class_name PlayerCommand

var player: Player


class HealthCommand extends PlayerCommand:
	var health: float
	
	
	func _init(_health: float, _player: Player) -> void:
		player = _player
		health = _health
	
	
	func excute() -> void:
		player.health_system.health = health


class SpeedCommand extends PlayerCommand:
	var speed: float
	
	func _init(_speed: float, _player: Player) -> void:
		player = _player
		speed = _speed
	
	
	func excute() -> void:
		player.speed = speed
