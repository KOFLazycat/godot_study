extends Area2D


var level = 1
var hp = 1
var speed = 100
var damage = 5
var knockback_amount = 100
var attack_size = 1.0

var target = Vector2.ZERO
var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite_2d = $Sprite2D

signal remove_from_array(object)


func _ready():
	angle = global_position.direction_to(target)
	rotation = angle.angle() + deg_to_rad(135)
	match level:
		1:
			hp = 2
			speed = 100
			damage = 5
			knockback_amount = 100
			attack_size = 0.8
	
	var tween = create_tween().set_parallel(false)
	tween.tween_property(self, "scale", Vector2(1,1)*attack_size, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	# tween.tween_property(self, "modulate", Color(1,0,0,1), 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
			

func _physics_process(delta):
	position += angle*speed*delta


func enemy_hit(charge = 1):
	hp -= charge
	if hp <= 0:
		emit_signal("remove_from_array", self)
		queue_free()


# 跑出很远没有命中敌人的话 定时消除
func _on_timer_timeout():
	queue_free()
