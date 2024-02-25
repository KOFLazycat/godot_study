class_name Interactable
extends Area2D

signal interacted


func _init() -> void:
	collision_layer = 0
	collision_mask = 0
	# 与Player层碰撞检测
	set_collision_mask_value(2, true)
	
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)


func _ready() -> void:
	pass


func interact() -> void:
	print("[Interact] %s" % name)
	interacted.emit()


func on_body_entered(player: Player) -> void:
	player.register_interactable(self)


func on_body_exited(player: Player) -> void:
	player.unregister_interactable(self)
