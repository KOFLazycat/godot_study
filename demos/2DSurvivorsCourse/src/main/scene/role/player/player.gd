extends CharacterBody2D

@onready var collision_area_2d: Area2D = $CollisionArea2D
@onready var damage_interval_timer: Timer = $DamageIntervalTimer
@onready var health_component: HealthComponent = $HealthComponent
@onready var health_bar: ProgressBar = $HealthBar
@onready var abilities: Node = $Abilities
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visuals: Node2D = $Visuals
@onready var sprite_2d: Sprite2D = $Visuals/Sprite2D

const MAX_SPEED: float = 150.0
const ACCELERATION_SMOOTHING = 25.0
var number_colliding_bodies: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_area_2d.body_entered.connect(on_body_entered)
	collision_area_2d.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	update_health_display()
	animation_player.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction: Vector2 = get_movement_vector()
	var target_velocity = direction * MAX_SPEED
	velocity = velocity.lerp(target_velocity, 1.0 - exp(-delta * ACCELERATION_SMOOTHING))
	move_and_slide()
	if direction != Vector2.ZERO:
		animation_player.play("walk")
	else:
		animation_player.play("idle")
	
	var move_sign: int = sign(direction.x)
	if move_sign != 0:
		visuals.scale.x = move_sign


func get_movement_vector() -> Vector2:
	var x_movement: float = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement: float = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement).normalized()


func check_deal_damage() -> void:
	if number_colliding_bodies == 0 || !damage_interval_timer.is_stopped():
		return
	health_component.damage(1)
	damage_interval_timer.start()


func update_health_display() -> void:
	health_bar.value = health_component.get_health_percent()


func on_body_entered(_body: Node2D) -> void:
	number_colliding_bodies += 1
	check_deal_damage()


func on_body_exited(_body: Node2D) -> void:
	number_colliding_bodies = max(number_colliding_bodies - 1, 0)


func on_damage_interval_timer_timeout() -> void:
	check_deal_damage()


func on_health_changed() -> void:
	update_health_display()


func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrade: Dictionary) -> void:
	if not ability_upgrade is Ability:
		return
	var ability = ability_upgrade as Ability
	abilities.add_child(ability.ability_controller_scene.instantiate())