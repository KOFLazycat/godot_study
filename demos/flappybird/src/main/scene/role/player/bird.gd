extends RigidBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D

var state = Game.idle #默认状态

var ypos=3	#上下飞行的距离
var filp=true
var flyspeed=25 #上下飞行的速度
var speed=200	#向上飞的速度
signal birdStateChange  #状态改变
var ani= ["idle","fly","flap"]
var ani2=["idle_blue","fly_blue","flap_blue"]
var ani3=["idle_yellow","fly_yellow","flap_yellow"]
var list=[ani,ani2,ani3]
var index=0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	index=randi()%3
	animated_sprite_2d.play(list[index][0])
	add_to_group(Game.group_bird)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if state==Game.idle:
		idle(delta)
	elif state==Game.fly:
		fly(delta)
	elif state==Game.play:
		play(delta)
	elif state==Game.dead:
		dead(delta)


#设置状态
func setState(newState:int):
	if newState==Game.idle:
		gravity_scale=0
	elif newState==Game.fly:
		gravity_scale=0
		animated_sprite_2d.play(list[index][1])
	elif newState==Game.play:
		gravity_scale=5
		flap()
	elif newState==Game.dead:
		angular_velocity=1.4
#		animated_sprite_2d.play("idle")
		animated_sprite_2d.play(list[index][0])
	state=newState


#拍动翅膀
func flap():
	if AudioPlayer:
		AudioPlayer.playSfxWing()
	animated_sprite_2d.play(list[index][2],true)
	linear_velocity.y=-speed
	angular_velocity=-3

#默认状态
func idle(delta):
	pass
	
#上下飞行的状态
func fly(delta):
	if filp:
		if animated_sprite_2d.position.y>ypos:
			filp=false
		else:
			animated_sprite_2d.position.y+=flyspeed*delta
	else:
		if animated_sprite_2d.position.y<-ypos:
			filp=true
		else:
			animated_sprite_2d.position.y-=flyspeed*delta


#游戏开始时 飞行的状态
func play(delta):
	if Input.is_action_just_pressed("ui_accept"):
		flap()
	
	#计算角度避免一直旋转
	if rotation_degrees<-30:
		rotation_degrees=-30
		angular_velocity=0
	
	if linear_velocity.y>0:
		angular_velocity=1.5
	
func dead(delta):
	pass


func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			if state==Game.play:
				flap()


func _on_body_entered(body):
	if state!=Game.play:	#不是开始的状态就跳过
		return
	if body.is_in_group(Game.group_ground):
		if AudioPlayer:
			AudioPlayer.playSfxHit()
		emit_signal("birdStateChange")
	elif body.is_in_group(Game.group_pipe):
		if AudioPlayer:
			AudioPlayer.playSfxHit()
			AudioPlayer.playSfxDie()
		emit_signal("birdStateChange")
		var other_body = get_colliding_bodies()[0]
		add_collision_exception_with(other_body)



