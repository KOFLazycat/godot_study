class_name Hitbox
extends Area2D
### 受到攻击的范围判定

signal hit(hurtbox)


func _init() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(hurtbox: Hurtbox) -> void:
	print("[HIT] %s => %s" % [owner.name, hurtbox.owner.name])
	hit.emit(hurtbox)
	hurtbox.hurt.emit(self)
