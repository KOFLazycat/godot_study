extends Area2D

@export var experience = 1

var spr_green = preload("res://Textures/Items/Gems/Gem_green.png")
var spr_blue = preload("res://Textures/Items/Gems/Gem_blue.png")
var spr_red = preload("res://Textures/Items/Gems/Gem_red.png")

var target = null
var speed = 0

@onready var sprite_2d = $Sprite2D
@onready var snd_collected = $SndCollected
@onready var collision_shape_2d = $CollisionShape2D


func _ready():
	if experience < 5:
		return
	elif experience < 25:
		sprite_2d.texture = spr_blue
	else:
		sprite_2d.texture = spr_red


func  _physics_process(delta):
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 2*delta
		
		
func collect():
	snd_collected.play()
	snd_collected.set_deferred("disabled", true)
	sprite_2d.visible = false
	return experience


func _on_snd_collected_finished():
	queue_free()
