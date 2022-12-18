extends StaticBody2D


@export var player_path = NodePath()
@onready var player = get_node(player_path)
@onready var projectileScene := preload("res://src/main/scene/role/projectile/projectile.tscn")
@onready var weapon = $Weapon
@onready var projectile_spawner = $Weapon/ProjectileSpawner
@onready var timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	timer.connect("timeout", Callable(self, "_shoot"))


func _physics_process(delta):
	weapon.look_at(player.global_position)
	

func _shoot():
	var projectile = projectileScene.instantiate()
	projectile.position = projectile_spawner.global_position
	projectile.direction = weapon.global_position.direction_to(projectile_spawner.global_position)
	add_child(projectile)
