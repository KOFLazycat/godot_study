extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var snd_collected: AudioStreamPlayer = $SndCollected
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


@export var experience: int = 1
var spr_green: Resource = preload("res://src/main/assets/texture/Items/Gems/Gem_green.png")
var spr_blue: Resource = preload("res://src/main/assets/texture/Items/Gems/Gem_blue.png")
var spr_red: Resource = preload("res://src/main/assets/texture/Items/Gems/Gem_red.png")
var target = null
var speed: float = -100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if experience < 5:
		return
	elif experience < 25:
		sprite_2d.texture = spr_blue
	else:
		sprite_2d.texture = spr_red


func _physics_process(delta: float) -> void:
	if target != null:
		global_position = global_position.move_toward(target.global_position, delta*speed)
		speed += 2


func grab() -> int:
	snd_collected.play()
	collision_shape_2d.set_deferred("disabled", true)
	sprite_2d.visible = false
	return experience


func _on_snd_collected_finished() -> void:
	queue_free()
