extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var bow: Sprite2D = $Bow
@onready var broadsword: Sprite2D = $Broadsword
@onready var blood: Node2D = $Blood
@onready var arrow_tscn = preload("res://src/main/scene/level/dungeons/arrow.tscn")


const SPEED:float = 300.0
var direction: Vector2 = Vector2.ZERO
# 武器总量
var weapon_num: int = 2
# 当前武器，0弓箭，1大刀
var current_weapon: int = 0
var rect: Rect2

func _ready() -> void:
	blood.blood_max = Global.g_hp_value
	blood.init()
	

func _physics_process(delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		animated_sprite_2d.play("run")
		if direction.x > 0:
			animated_sprite_2d.flip_h = false
		if direction.x < 0:
			animated_sprite_2d.flip_h = true
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED/4)
		animated_sprite_2d.play("idle")

	move_and_slide()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("change_weapon"):
		current_weapon += 1
		if current_weapon >= weapon_num:
			current_weapon = 0
	
	match current_weapon:
		0:
			bow.show()
			broadsword.hide()
			if Input.is_action_just_pressed("shoot"):
				var arrow = arrow_tscn.instantiate()
				get_parent().add_child(arrow)
				arrow.shot(bow.dir, bow.fire_pos)
		1:
			bow.hide()
			broadsword.show()
			rect = Rect2(Vector2(global_position.x - 30, global_position.y - 30), Vector2(60, 60))
			if rect.has_point(get_global_mouse_position()) != true:
				if Input.is_action_just_pressed("shoot"):
					broadsword.stab()
				if Input.is_action_just_released("shoot"):
					broadsword.reset()


func _on_area_2d_body_entered(body: Node2D) -> void:
	Global.g_hp_value -= 20
	blood.value_change(-20)
	if Global.g_hp_value <= 0:
		get_tree().reload_current_scene()
