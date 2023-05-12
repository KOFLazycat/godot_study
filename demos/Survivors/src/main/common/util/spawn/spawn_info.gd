extends Resource

class_name SpawnInfo

# 敌人产生起始时间
@export var time_start: float
# 敌人产生截止时间
@export var time_end: float
# 敌人
@export var enemy: Resource
# 每次生产的敌人数量
@export var enemy_num: float
# 每次生产敌人距离上一次生产延迟（单位：秒）
@export var enemy_spawn_delay: float

# 生产延时统计（单位：秒）
var spawn_delay_counter = 0
