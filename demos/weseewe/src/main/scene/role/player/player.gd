extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready var label = %Label
@onready var bg = $Bg


var speed=550	#跳跃速度
var gravity=1400

var animationInterval=240
var animationTime=0

var rotateDeg=0
var rotateSpeed=370
var jumpAgain=true	#再次跳跃

var state = Game.playerState.IDLE

func _ready():
	velocity = Vector2.ZERO	#速度
	add_to_group("player")


func _physics_process(delta):
	if state==Game.playerState.IDLE:
		idle(delta)
	elif state==Game.playerState.STAND:
		stand(delta)
	elif state==Game.playerState.JUMP:
		jump(delta)
	elif state==Game.playerState.DEAD:
		dead(delta)
	
	animationTime+=1
	if animationTime>animationInterval:
		animationTime=0
		animated_sprite_2d.play("blink",true)


func setState(state):
	self.state=state

	
func playAni():
	label.text=Game.words[randi()%Game.words.size()]
	animation_player.play("show")

#显示新分数
func playMewScoreAni():
	label.text="you got new score"
	animation_player.play("show")


func idle(delta):
	velocity.y+=gravity*delta
	move_and_slide()
	
	if is_on_floor():
		jumpAgain=true
		rotateDeg=0
		animated_sprite_2d.rotation_degrees=0
		bg.rotation_degrees=0
		

func stand(delta):
	velocity.y+=gravity*delta
	if Input.is_action_pressed("jump"):
		Sound.playJumpA()
		velocity.y=-speed
		state=Game.playerState.JUMP
		return
	move_and_slide()
	
	if is_on_floor():
		jumpAgain=true
		rotateDeg=0
		animated_sprite_2d.rotation_degrees=0
		bg.rotation_degrees=0


func jump(delta):
	velocity.y+=gravity*delta
	if Input.is_action_just_pressed("jump") and jumpAgain:
		Sound.playJumpB()
		velocity.y=-speed
		jumpAgain=false
	
	rotateDeg+=rotateSpeed*delta
	animated_sprite_2d.rotation_degrees=round(rotateDeg)
	bg.rotation_degrees=round(rotateDeg)
	if rotateDeg>360:
		rotateDeg=0	
	move_and_slide()	
	if is_on_floor():
		jumpAgain=true
		state=Game.playerState.STAND
		rotateDeg=0
		animated_sprite_2d.rotation_degrees=0
		bg.rotation_degrees=0

func dead(delta):
	pass


#func _unhandled_input(event):
#	if event is InputEventScreenTouch or event is InputEventMouseButton:
#		if event.pressed or (event is InputEventMouseButton and 
#							event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
#			if state==Game.playerState.STAND:
#				Sound.playJumpA()
#				velocity.y=-speed
#				state=Game.playerState.JUMP
#			elif state==Game.playerState.JUMP and jumpAgain:
#				Sound.playJumpB()
#				velocity.y=-speed
#				jumpAgain=false
