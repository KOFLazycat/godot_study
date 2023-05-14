extends CharacterBody2D


@onready var player = get_tree().get_first_node_in_group("player")
@onready var loot_base = get_tree().get_first_node_in_group("loot")
@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var sng_hit: AudioStreamPlayer = $SngHit
@onready var explosion_tscn = preload("res://src/main/scene/role/enemy/kolbold_weak/explosion.tscn")
@onready var experience_gem_tscn = preload("res://src/main/scene/role/gem/experience_gem.tscn")


@export var movement_speed: float = 20.0
@export var hp: float = 10.0
@export var knockback_recovery: float = 3.5
@export var experience = 1
var knockback: Vector2 = Vector2.ZERO

#signal remove_from_array(obj)

func _ready():
	animation_player.play("walk")


func _physics_process(_delta):
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	var direction = global_position.direction_to(player.global_position)
	if direction.x > 0:
		sprite_2d.flip_h = true
	if direction.x < 0:
		sprite_2d.flip_h = false
	velocity = direction * movement_speed
	velocity += knockback
	move_and_slide()


func _on_hurt_box_hurt(damage: float, knockback_amount: float, angle: Vector2) -> void:
	hp -= damage
	knockback = angle * knockback_amount
	if hp <= 0:
		death()
	else:
		sng_hit.play()


func death() -> void:
#		emit_signal("remove_from_array", self)
		var explosion = explosion_tscn.instantiate()
		explosion.global_position = global_position
		get_parent().call_deferred("add_child", explosion)
		var experience_gem = experience_gem_tscn.instantiate()
		experience_gem.global_position = global_position
		experience_gem.experience = experience
		loot_base.call_deferred("add_child", experience_gem)
		queue_free()
