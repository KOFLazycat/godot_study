extends CharacterBody2D


@export var movement_speed = 20.0
@export var hp = 10
@export var knockback_recovery = 3.5
@export var experience = 1#死亡掉落经验
@export var damage = 1
var knockback = Vector2.ZERO
@onready var player = get_tree().get_first_node_in_group("player")
@onready var loot_base = get_tree().get_first_node_in_group("loot")
@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var snd_hit = $SndHit
@onready var hit_box = $HitBox

var death_anim = preload("res://Enemy/explosion.tscn")
var exp_gem = preload("res://Objects/experience_gem.tscn")


signal remove_from_array(object)


func _ready():
	animation_player.play("enemy_kolbold_weak_walk")
	hit_box.damage = damage


func _physics_process(_delta):
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	var direction = global_position.direction_to(player.global_position)
	# 增加余量可以让怪物转向增加一点反应时间，看起来相对真实
	if direction.x > 0.1:
		sprite_2d.flip_h = true
	if direction.x < -0.1:
		sprite_2d.flip_h = false
	
	velocity = direction*movement_speed
	velocity += knockback
		
	move_and_slide()


func _on_hurt_box_hurt(damage, angle, knockback_amount):
	hp -= damage
	knockback = angle * knockback_amount
	print("EnemyHp: " + str(hp))
	if hp <= 0:
		death()
	else:
		snd_hit.play()


func death():
	emit_signal("remove_from_array", self)
	var enemy_death = death_anim.instantiate()
	enemy_death.scale = sprite_2d.scale
	enemy_death.global_position = global_position
	get_parent().call_deferred("add_child", enemy_death)
	var new_gem = exp_gem.instantiate()
	new_gem.global_position = global_position
	print(new_gem.experience)
	new_gem.experience = experience
	loot_base.call_deferred("add_child", new_gem)
	queue_free()
