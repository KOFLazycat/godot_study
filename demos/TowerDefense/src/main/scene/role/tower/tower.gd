class_name Tower
extends StaticBody2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $Area2DAttackRange/CollisionShape2D
@onready var timer_fire_interval: Timer = $TimerFireInterval
@onready var bullet_tscn = preload("res://src/main/scene/role/bullet/shuriken/bullet_shuriken.tscn") as PackedScene


# 攻击范围是否可见
var is_show_attack_range: bool = false
enum AttackRangeColor {
	GREEN,
	RED,
}
# 攻击范围圈
var range_color: Color = Color(0.498039, 1, 0, 0.2)
# 攻击范围圈，绿色
var range_green: Color = Color(0.498039, 1, 0, 0.2)
# 攻击范围圈，红色
var range_red: Color = Color(1, 0, 0, 0.5)
# 炮塔攻击范围
var attack_range: int = 300
# 攻击对象
var target_array: Array = []
# 攻击间隔，单位秒
var fire_interval: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer_fire_interval.start(fire_interval)
	collision_shape_2d.shape.radius = attack_range


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	

# 绘图 攻击范围圈
func _draw() -> void:
	# 攻击范围可见的话，需要绘制
	if is_show_attack_range:
		draw_circle(Vector2.ZERO, attack_range, range_color)


# 设置攻击范围圈颜色
func show_attack_range_with_color(is_show: bool, color_type: int) -> void:
	is_show_attack_range = is_show
	if is_show:
		match color_type:
			AttackRangeColor.GREEN:
				range_color = Color(0.498039, 1, 0, 0.2)
			AttackRangeColor.RED:
				range_color = Color(1, 0, 0, 0.5)
			_:
				range_color = Color(0.498039, 1, 0, 0.2)
	queue_redraw()

# 鼠标进入时显示攻击范围
func _on_mouse_entered() -> void:
	show_attack_range_with_color(true, AttackRangeColor.GREEN)

# 鼠标移出时不显示攻击范围
func _on_mouse_exited() -> void:
	show_attack_range_with_color(false, AttackRangeColor.GREEN)


func _on_area_2d_attack_range_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		target_array.append(area)


func _on_area_2d_attack_range_area_exited(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		target_array.erase(area)


func _on_timer_fire_interval_timeout() -> void:
	if target_array.size() > 0:
		var bullet = bullet_tscn.instantiate()
		bullet.fire(animated_sprite_2d.global_position, target_array[0])
		get_tree().root.add_child(bullet)
#		var parent = get_parent()
#		if is_instance_valid(parent):
#			parent.add_child(bullet)
#		else:
#			add_child(bullet)



