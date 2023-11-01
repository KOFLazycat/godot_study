extends StaticBody2D

signal energy_brick_destroyed()
signal destroyed(which)

@export var long_full: CompressedTexture2D = preload("res://scenes/brick/visuals/BlockLongFull.png")
@export var long_border: CompressedTexture2D = preload("res://scenes/brick/visuals/BlockLongBorder.png")
@export var small_full: CompressedTexture2D = preload("res://scenes/brick/visuals/BlockSmallFull.png")
@export var small_border: CompressedTexture2D = preload("res://scenes/brick/visuals/BlockSmallBorder.png")

@export var one: CompressedTexture2D = preload("res://scenes/brick/visuals/One.png")
@export var two: CompressedTexture2D = preload("res://scenes/brick/visuals/Two.png")
@export var three: CompressedTexture2D = preload("res://scenes/brick/visuals/Three.png")
@export var bomb: CompressedTexture2D = preload("res://scenes/brick/visuals/Bomb.png")
@export var energy: CompressedTexture2D = preload("res://scenes/brick/visuals/Energy.png")

enum TYPE {
	ONE,
	TWO,
	THREE,
	EXPLOSIVE,
	ENERGY
}

enum SIZE {
	SMALL,
	LONG
}

@export var type: TYPE = TYPE.ONE
@export var size: SIZE = SIZE.SMALL

var health_dict = {
	TYPE.ONE: 1,       # 0.35
	TYPE.TWO: 2,       # 0.3
	TYPE.THREE: 3,	   # 0.20
	TYPE.EXPLOSIVE: 1, # 0.05
	TYPE.ENERGY: 1,    # 0.1
}

@onready var health: int = health_dict[type]
@onready var explosion_area: Area2D = $ExplosionArea
@onready var size_sprite: Sprite2D = $Size
@onready var type_sprite: Sprite2D = $Type

var _destroyed: bool = false

func _ready() -> void:
	choose_type_random()
	choose_size_random()
	
	health = health_dict[type]
	
	update_size_visuals()
	update_type_visuals()

func choose_type_random() -> void:
	var rand = randf()
	# 10% chance for explosives
	if rand < 0.05:
		type = TYPE.EXPLOSIVE
	elif rand >= 0.05 && rand < 0.15:
		type = TYPE.ENERGY
	elif rand >= 0.15 && rand < 0.35:
		type = TYPE.THREE
	elif rand >= 0.35 && rand < 0.65:
		type = TYPE.TWO
	else:
		type = TYPE.ONE
		
#	type = randi()%TYPE.size()
	
func choose_size_random() -> void:
	var rand = randf()
	if rand < 0.65:
		size = SIZE.LONG
	else:
		size = SIZE.SMALL

func update_size_visuals() -> void:
	match size:
		SIZE.SMALL:
			$CollisionShapeSmall.disabled = false
			$CollisionShapeLong.disabled = true
			if type == TYPE.EXPLOSIVE or type == TYPE.ENERGY:
				size_sprite.texture = small_border
			else:
				size_sprite.texture = small_full
		SIZE.LONG:
			$CollisionShapeSmall.disabled = true
			$CollisionShapeLong.disabled = false
			if type == TYPE.EXPLOSIVE or type == TYPE.ENERGY:
				size_sprite.texture = long_border
			else:
				size_sprite.texture = long_full

func update_type_visuals() -> void:
	match type:
		TYPE.ONE:
			type_sprite.texture = one
		TYPE.TWO:
			type_sprite.texture = two
		TYPE.THREE:
			type_sprite.texture = three
		TYPE.EXPLOSIVE:
			type_sprite.texture = bomb
		TYPE.ENERGY:
			type_sprite.texture = energy

func damage(value: int) -> void:
	health -= value
	
	if health <= 0:
		_destroyed = true
		match type:
			TYPE.EXPLOSIVE:
				explode()
			TYPE.ENERGY:
				give_energy()
		destroy()
	
	update_type_health()

func update_type_health() -> void:
	match health:
		3:
			type = TYPE.THREE
		2:
			type = TYPE.TWO
		1:
			type = TYPE.ONE
	update_type_visuals()
		
func give_energy() -> void:
	emit_signal("energy_brick_destroyed")

func explode() -> void:
	var bodies = explosion_area.get_overlapping_bodies()
	for body in bodies:
		if body._destroyed: continue
		# Damage with a high enough value to make sure
		# they're destroyed but also trigger any eventual
		# explosive bricks
		body.damage(10)

func destroy() -> void:
	emit_signal("destroyed", self)
	queue_free()
