extends Node2D


@export var speed = 1000.0
@export var lifetime = 3.0
var direction = Vector2.ZERO

@onready var timer = $Timer
@onready var common_hit_box = $CommonHitBox
@onready var impact_detector = $ImpactDetector
@onready var sprite_2d = $Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_top_level(true)
	look_at(position + direction)
	timer.connect("timeout", Callable(self, "queue_free"))
	timer.start()
	impact_detector.connect("body_entered", Callable(self, "_on_impact"))


func _physics_process(delta):
	position += direction * speed * delta
	
	
func _on_impact(_body):
	queue_free()
