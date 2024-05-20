extends Node2D

@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

# spring当前速度
var velocity: float = 0.0
# 对spring施加的力
var force: float = 0.0
# 高度
var height: float = 0
# 稳定状态高度
var target_height: float = 0


func water_update(spring_constant: float, dampening: float) -> void:
	# 更新当前高度
	height = position.y
	# 获取当前拉伸长度
	var x: float = height - target_height
	var loss: float = - dampening * velocity
	# 胡克定律
	force = - spring_constant * x + loss
	
	# 对速度施加力
	velocity += force
	# 移动位置
	position.y += velocity


func initialize(x_position: float) -> void:
	height = position.y
	target_height = position.y
	velocity = 0
	position.x = x_position


func set_collision_width(value: float) -> void:
	## TODO 需要设置碰撞宽度和形状
	var extend = collision_shape_2d.shape.size()



















