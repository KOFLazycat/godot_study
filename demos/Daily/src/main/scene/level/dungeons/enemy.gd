extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var blood: Node2D = $Blood
@onready var gold_tscn = preload("res://src/main/scene/level/dungeons/gold.tscn")


const SPEED: float = 30.0
var dir: Vector2 = Vector2.ZERO
var ani_enemy: Array = ["enemy1", "enemy2", "enemy3", "enemy4"]
var hp: int = 100

func _ready() -> void:
	animated_sprite_2d.play(ani_enemy[randi_range(0, 3)])
	blood.blood_max = hp
	blood.init()


func _physics_process(delta: float) -> void:
	if dir != Vector2.ZERO:
		velocity = dir * SPEED
		if dir.x > 0:
			animated_sprite_2d.flip_h = false
		if dir.x < 0:
			animated_sprite_2d.flip_h = true
	else:
		velocity = velocity.move_toward(Vector2.ZERO, 10.0)

	move_and_slide()


func death() -> void:
	call_deferred("spawn_coin")
	queue_free()


func spawn_coin() -> void:
	var gold = gold_tscn.instantiate()
	get_parent().add_child(gold)
	var gold2 = gold_tscn.instantiate()
	get_parent().add_child(gold2)
	var gold3 = gold_tscn.instantiate()
	get_parent().add_child(gold3)
	var gold4 = gold_tscn.instantiate()
	get_parent().add_child(gold4)
	gold.play_coin(self.position + Vector2(-30, -30))
	gold2.play_coin(self.position + Vector2(30, -30))
	gold3.play_coin(self.position + Vector2(-30, 30))
	gold4.play_coin(self.position + Vector2(30, 30))


func _on_area_2d_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		dir = (body.global_position - self.global_position).normalized()


func _on_area_2d_detection_body_exited(body: Node2D) -> void:
	dir = Vector2.ZERO


func _on_area_2d_area_entered(area: Area2D) -> void:
	hp -= 20
	blood.value_change(-20)
	if hp <= 0:
		death()
