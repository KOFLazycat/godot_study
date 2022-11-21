extends Area2D


var level = 1
var hp = 9999
var speed = 200
var damage = 10
var attack_size = 1.0
var attack_speed = 4.0
var knockback_amount = 100
var paths = 1


var target = Vector2.ZERO
var target_array = []
var angle = Vector2.ZERO
var reset_pos = Vector2.ZERO

var spr_jav_reg = preload("res://Textures/Items/Weapons/javelin_3_new.png")
var spr_jav_atk = preload("res://Textures/Items/Weapons/javelin_3_new_attack.png")

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var attack_timer = %AttackTimer
@onready var change_direction_timer = %ChangeDirectionTimer
@onready var reset_pos_timer = %ResetPosTimer
@onready var snd_attack = $SndAttack

signal remove_from_array(ogject)


func _ready():
	update_javelin()


func update_javelin():
	level = player.javelin_level
	match level:
		1:
			hp = 9999
			speed = 200
			damage = 10
			attack_size = 1.0
			attack_speed = 4.0
			knockback_amount = 100
			paths = 1
	scale = Vector2(1.0,1.0)*attack_size
	attack_timer.wait_time = attack_speed
	

func _physics_process(delta):
	if target_array.size() > 0:
		position += angle*speed*delta


func add_path():
	pass


func _on_attack_timer_timeout():
	add_path()



