extends RigidBody2D

@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var animal: RigidBody2D = $"."
@onready var stretch_sound: AudioStreamPlayer2D = $StretchSound
@onready var launch_sound: AudioStreamPlayer2D = $LaunchSound
@onready var collision_sound: AudioStreamPlayer2D = $CollisionSound
@onready var arrow_sprite_2d: Sprite2D = $ArrowSprite2D

const DRAG_LIM_MAX: Vector2 = Vector2(0, 60)
const DRAG_LIM_MIN: Vector2 = Vector2(-60, 0)
const IMPULSE_MULT: float = 10.0
const IMPULSE_MAX: float = 1200.0
const FIRE_DELAY: float = 0.25
const STOPPED: float = 0.1

var _dead: bool = false
var _dragging: bool = false
var _released: bool = false
var _start: Vector2 = Vector2.ZERO
var _drag_start: Vector2 = Vector2.ZERO
var _dragged_vector: Vector2 = Vector2.ZERO
var _last_dragged_position: Vector2 = Vector2.ZERO
var _last_drag_amount: float = 0.0
var _fired_time: float = 0.0
var _arrow_scale_x: float = 0.0
var _last_collision_count: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible_on_screen_notifier_2d.screen_exited.connect(on_visible_on_screen_notifier_2d_screen_exited)
	animal.input_event.connect(on_animal_input_event)
	_start = global_position
	_arrow_scale_x = arrow_sprite_2d.scale.x
	arrow_sprite_2d.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	update_debug_label()
	
	if _released:
		_fired_time += delta
		if _fired_time > FIRE_DELAY:
			play_collision()
			check_on_target()
	else:
		if !_dragging:
			return
		else:
			if Input.is_action_just_released("drag"):
				release_it()
			else:
				drag_it()


func update_debug_label() -> void:
	var s: String = "g_pos: %s, contacts: %s\n" % [
		VecUtils.vec2_to_str(global_position),
		get_contact_count()
	]
	s += "_dragging: %s, _released: %s\n" % [
		_dragging,
		_released
	]
	s += "_start: %s, _drag_start: %s, _dragged_vector: %s\n" % [
		VecUtils.vec2_to_str(_start),
		VecUtils.vec2_to_str(_drag_start),
		VecUtils.vec2_to_str(_dragged_vector)
	]
	s += "_last_dragged_position: %s, _last_drag_amount: %.1f\n" % [
		VecUtils.vec2_to_str(_last_dragged_position),
		_last_drag_amount
	]
	s += "ang: %.1f, linear: %s, _fired_time: %.1f" % [
		angular_velocity,
		VecUtils.vec2_to_str(linear_velocity),
		_fired_time
	]
	SignalManager.update_debug_label.emit(s)


func scale_arrow() -> void:
	var imp_len = get_impulse().length()
	var perc = imp_len / IMPULSE_MAX
	arrow_sprite_2d.scale.x = (_arrow_scale_x * perc) + _arrow_scale_x
	arrow_sprite_2d.rotation = (_start - global_position).angle()


func stopped_rolling() -> bool:
	if get_contact_count() > 0:
		if (
			abs(linear_velocity.y) < STOPPED
			and abs(angular_velocity) < STOPPED
		):
			return true
		
	return false


func check_on_target() -> void:
	if stopped_rolling() == false:
		return
	var cb = get_colliding_bodies()
	if cb.size() == 0:
		return
	
	var cup: Node2D = cb[0]
	if cup.is_in_group(GameManager.GROUP_CUP):
		cup.die()
		die()


func play_collision() -> void:
	if (
		_last_collision_count == 0 
		and get_contact_count() > 0
		and !collision_sound.playing
	):
		collision_sound.play()
	_last_collision_count = get_contact_count()


func grab_it() -> void:
	_dragging = true
	_drag_start = get_global_mouse_position()
	_last_dragged_position = _drag_start
	arrow_sprite_2d.show()


func drag_it() -> void:
	var gmp = get_global_mouse_position()
	_last_drag_amount = (_last_dragged_position - gmp).length()
	_last_dragged_position = gmp
	
	if _last_drag_amount > 0 and !stretch_sound.playing:
		stretch_sound.play()
	
	_dragged_vector = _last_dragged_position - _drag_start
	_dragged_vector.x = clampf(_dragged_vector.x, DRAG_LIM_MIN.x, DRAG_LIM_MAX.x)
	_dragged_vector.y = clampf(_dragged_vector.y, DRAG_LIM_MIN.y, DRAG_LIM_MAX.y)
	global_position = _start + _dragged_vector
	
	scale_arrow()


func release_it() -> void:
	_dragging = false
	_released = true
	freeze = false
	apply_central_impulse(get_impulse())
	stretch_sound.stop()
	launch_sound.play()
	ScoreManger.attempt_made()
	arrow_sprite_2d.hide()


func get_impulse() -> Vector2:
	return _dragged_vector * -1 * IMPULSE_MULT


func die() -> void:
	if _dead:
		return
	_dead = true
	SignalManager.animal_die.emit()
	queue_free()


func on_visible_on_screen_notifier_2d_screen_exited() -> void:
	die()


func on_animal_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if _dragging or _released:
		return
	
	if event.is_action_pressed("drag"):
		grab_it()
