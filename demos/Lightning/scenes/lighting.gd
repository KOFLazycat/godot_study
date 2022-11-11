extends Line2D

@onready var flash_animation = $FlashAnimation

@export var Arc: int = 100 #扭曲次数（随机数）
@export var RandRange: int = 10 #随机偏移量
@export var LightingPath: PackedVector2Array #闪电路径
@export var LightingSpeed: float = 0.002 #闪电速度
@export var LightingFlashTime: float = 0.05 #闪电生成后多久画面开始闪烁
@export var LightingDisappearTime: float = 0.5 #画面闪烁后多久消失

@export var Division: int = 80 #随机分裂次数
@export var Division1: PackedVector2Array #分裂路径1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.points = LightingPath
	
	
func set_lighting():
	self.modulate = Color(1,1,1,1)#恢复透明度
	LightingPath.clear()#清空闪电路径
	
	# 生成起始和终点
	# TODO A、B可设置随机值
	var PosA := Vector2(randf_range(480, 1440), -10)
	var PosB := Vector2(randf_range(0, 1920), randf_range(810, 1080))
	LightingPath.append(PosA)
	
	var LastPos := Vector2.ZERO
	var NextPos := Vector2.ZERO
	for N in (Arc - 2):
		LastPos = LightingPath[LightingPath.size()-1]
		NextPos = LastPos + (PosB - LastPos)/(Arc - 1 -N) + Vector2(randf_range(-RandRange, RandRange), randf_range(-RandRange, RandRange))
		LightingPath.append(NextPos)
		# 每隔一段时间再增加下一个节点，这样看起来闪电是一点一点形成的
		await get_tree().create_timer(LightingSpeed).timeout
	
	#设置终点
	LightingPath.append(PosB)
	
	#画面闪烁
	await get_tree().create_timer(LightingFlashTime).timeout
	flash_animation.play("flash")
	
	#消失
	await flash_animation.animation_finished
	var disappear = create_tween()
	disappear.tween_property(self, "modulate", Color(0,0,0,0), LightingDisappearTime).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	disappear.play()


func _on_timer_timeout():
	set_lighting()
	pass # Replace with function body.
