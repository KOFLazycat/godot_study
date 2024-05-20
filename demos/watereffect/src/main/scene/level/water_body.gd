extends Node2D

## 倔强系数，是一个常数
@export var k: float = 0.015
## 阻尼值，控制运动停下来的时间
@export var d: float = 0.03
## 扩散系数，判断运动会扩散多少次
@export var spread: float = 0.0002
## 每个spring相距的距离
@export var distance_between_springs: float = 36.0
## 场景中spring的数量
@export var spring_number: int = 6
## 水深
@export var depth: float = 1000.0
## 水面厚度
@export var border_thickness: float = 1.1


@onready var water_spring: PackedScene = preload("res://src/main/scene/level/water_spring.tscn")
@onready var water_polygon: Polygon2D = $WaterPolygon
@onready var water_border: SmoothPath = $WaterBorder
@onready var timer: Timer = $Timer

var springs: Array = []
var passes: int = 8
var water_length: float = distance_between_springs * spring_number
var target_height: float = global_position.y
var bottom: float = 0.0

func _ready() -> void:
	for i in range(spring_number):
		var x_position: float = distance_between_springs * i
		var w: Node2D = water_spring.instantiate()
		add_child(w)
		w.initialize(x_position)
		springs.append(w)
	
	water_border.width = border_thickness
	bottom = target_height + depth
	
	timer.timeout.connect(on_timer_timeout)


func _physics_process(delta: float) -> void:
	for i in springs:
		i.water_update(k, d)
	
	var left_deltas: Array = []
	var right_deltas: Array = []
	
	for i in range (springs.size()):
		left_deltas.append(0)
		right_deltas.append(0)
	
	for j in range(passes):
		for i in range (springs.size()):
			if i > 0:
				left_deltas[i] = spread * (springs[i].height - springs[i - 1].height)
				springs[i - 1].velocity += left_deltas[i]
			if i < springs.size() - 1:
				right_deltas[i] = spread * (springs[i].height - springs[i + 1].height)
				springs[i + 1].velocity += right_deltas[i]
	new_border()
	draw_water_body()


# 给指定索引spring增加个速度
func splash(index: int, speed: float) -> void:
	if index >= 0 and index < springs.size():
		springs[index].velocity += speed


func draw_water_body() -> void:
	var curve: Resource = water_border.curve
	var points: Array = Array(curve.get_baked_points())
	var water_polygon_points: Array = points
	
	var first_index: int = 0
	var last_index: int = water_polygon_points.size() - 1
	
	water_polygon_points.append(Vector2(water_polygon_points[last_index].x, bottom))
	water_polygon_points.append(Vector2(water_polygon_points[first_index].x, bottom))
	water_polygon_points = PackedVector2Array(water_polygon_points)
	water_polygon.polygon = PackedVector2Array(water_polygon_points)


func new_border() -> void:
	var curve: Resource = Curve2D.new().duplicate()
	
	var surface_points: Array = []
	for i in range(springs.size()):
		surface_points.append(springs[i].position)
	
	for i in range(surface_points.size()):
		curve.add_point(surface_points[i])
	water_border.curve = curve
	water_border.smooth = true
	water_border.update()


func on_timer_timeout() -> void:
	splash(randi_range(1, 20), randi_range(3, 8))






