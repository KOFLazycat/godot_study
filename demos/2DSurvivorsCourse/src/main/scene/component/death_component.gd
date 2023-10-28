extends Node2D

@export var health_component: Node
@export var sprite: Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var hit_random_audio_player_component: AudioStreamPlayer2D = $HitRandomAudioPlayerComponent


func _ready() -> void:
	gpu_particles_2d.texture = sprite.texture
	health_component.died.connect(on_died)


func on_died() -> void:
	var entities: Node2D = get_tree().get_first_node_in_group("entities_layer") as Node2D
	get_parent().remove_child(self)
	entities.add_child(self)
	global_position = sprite.global_position
	animation_player.play("default")
	hit_random_audio_player_component.play_random()
