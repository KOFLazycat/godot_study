extends CharacterBody2D


@export var movement_speed = 20.0
@export var hp = 10
@onready var player = get_tree().get_first_node_in_group("player")
@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D


func _ready():
	animation_player.play("enemy_kolbold_weak_walk")


func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	# 增加余量可以让怪物转向增加一点反应时间，看起来相对真实
	if direction.x > 0.1:
		sprite_2d.flip_h = true
	if direction.x < -0.1:
		sprite_2d.flip_h = false
	
	velocity = direction*movement_speed
	move_and_slide()


func _on_hurt_box_hurt(damage):
	hp -= damage
	print("EnemyHp: " + str(hp))
	if hp <= 0:
		queue_free()
