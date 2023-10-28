extends Node2D

@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hit_random_audio_player_component: AudioStreamPlayer2D = $HitRandomAudioPlayerComponent


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.area_entered.connect(on_area_entered)


func tween_collect(percent: float, start_position: Vector2) -> void:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if !is_instance_valid(player):
		return
	global_position = start_position.lerp(player.global_position, percent)
	var direction_from_start: Vector2 = player.global_position - start_position
	
	var target_rotation = direction_from_start.angle() + deg_to_rad(90)
	rotation = lerp_angle(rotation, target_rotation, 1.0 - exp(-5 * get_process_delta_time()))


func collect() -> void:
	GameEvents.emit_experience_vial_collected(1)
	queue_free()


func on_area_entered(_area: Area2D) -> void:
	var tween = create_tween()
	# 后面的tween并行进行
	tween.set_parallel(true)
	# tween 指定方法
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	# tween_property指定属性变化，并设置延迟
	tween.tween_property(sprite_2d, "scale", Vector2.ZERO, 0.15).set_delay(0.35)
	# 结束并行，后面的会串行
	tween.chain()
	tween.tween_callback(collect)
	collision_shape_2d.set_deferred("disabled", true)
	hit_random_audio_player_component.play_random()
