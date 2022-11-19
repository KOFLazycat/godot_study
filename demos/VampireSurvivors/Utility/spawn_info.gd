extends Resource

class_name SpawnInfo

#enemy 产生起始时间
@export var time_start:int
#enemy 产生截止时间
@export var time_end:int
#enemy 资源tscn
@export var enemy:Resource
#enemy 数量
@export var enemy_num:int
#enemy 产生延迟时间
@export var enemy_spawn_delay:int
#enemy 产生延迟计时器
var spawn_delay_counter:int = 0
