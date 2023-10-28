extends CharacterBody2D

@onready var velocity_component: Node = $VelocityComponent
@onready var visuals: Node2D = $Visuals
@onready var hit_random_audio_player_component: AudioStreamPlayer2D = $HitRandomAudioPlayerComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
var is_moving: bool = false


func _ready() -> void:
	hurtbox_component.hit.connect(on_hit)


func _process(_delta: float) -> void:
	if is_moving:
		velocity_component.accelerate_to_player()
	else:
		velocity_component.decelerate()
	
	velocity_component.move(self)
	var move_sign: int = sign(velocity.x)
	if move_sign != 0:
		visuals.scale.x = move_sign


func set_is_moving(moving: bool) -> void:
	is_moving = moving


func on_hit() -> void:
	hit_random_audio_player_component.play_random()
