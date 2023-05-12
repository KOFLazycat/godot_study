extends Area2D

@onready var timer: Timer = $Timer
@onready var snd_play: AudioStreamPlayer = $SndPlay
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var player = get_tree().get_first_node_in_group("player")


var level: int = 1
var hp: float = 1.0
var speed: float = 100.0
var damage: float = 5.0
var knockback_amount: float = 100.0
var attack_size: float = 1.0
# 飞行最大时间
var max_interval: int = 10

var target: Vector2 = Vector2.ZERO
var angle: Vector2 = Vector2.ZERO

signal remove_from_array(obj)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	angle = global_position.direction_to(target)
	rotation = angle.angle() + deg_to_rad(-45)
	match level:
		1:
			hp = 2.0
			speed = 100.0
			damage = 5.0
			knockback_amount = 100.0
			attack_size = 1.0 * (1 + player.spell_size)
		2:
			hp = 1.0
			speed = 100.0
			damage = 5.0
			knockback_amount = 100.0
			attack_size = 1.0 * (1 + player.spell_size)
		3:
			hp = 2.0
			speed = 100.0
			damage = 5.0
			knockback_amount = 100.0
			attack_size = 1.0 * (1 + player.spell_size)
		4:
			hp = 1.0
			speed = 100.0
			damage = 5.0
			knockback_amount = 100.0
			attack_size = 1.0 * (1 + player.spell_size)
	
#	var tween = create_tween().set_parallel(true)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1,1)*attack_size, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.chain().tween_property(self, "modulate", Color(1, 0, 0, 0.5), 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
#	tween.tween_callback(Callable(self, "_on_timer_timeout"))
	tween.play()
	timer.start(max_interval)


func _physics_process(delta: float) -> void:
	position += angle * speed * delta


func enemy_hit(charge: float = 1.0) -> void:
	hp -= charge
	print(hp)
	if hp <= 0:
		emit_signal("remove_from_array", self)
		queue_free()


func _on_timer_timeout() -> void:
	emit_signal("remove_from_array", self)
	queue_free()
