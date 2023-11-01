extends Node

@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene

var current_upgrades = {}
var upgrade_pool: WeightedTable = WeightedTable.new()
var upgrade_axe = preload("res://src/main/assets/resources/upgrades/axe.tres")
var upgrade_axe_damage = preload("res://src/main/assets/resources/upgrades/axe_damage.tres")
var upgrade_sword_rate = preload("res://src/main/assets/resources/upgrades/sword_rate.tres")
var upgrade_sword_damage = preload("res://src/main/assets/resources/upgrades/sword_damage.tres")
var upgrade_player_speed = preload("res://src/main/assets/resources/upgrades/player_speed.tres")
var upgrade_anvil = preload("res://src/main/assets/resources/upgrades/anvil.tres")
# 升级卡片数量
var max_pick_card_num: int = 3


func _ready() -> void:
	upgrade_pool.add_itme(upgrade_axe, 10)
	upgrade_pool.add_itme(upgrade_anvil, 10)
	upgrade_pool.add_itme(upgrade_sword_rate, 10)
	upgrade_pool.add_itme(upgrade_sword_damage, 10)
	upgrade_pool.add_itme(upgrade_player_speed, 5)
	experience_manager.level_up.connect(on_level_up)


func update_upgrade_pool(chosen_upgrade: AbilityUpgrade) -> void:
	if chosen_upgrade.id == upgrade_axe.id:
		upgrade_pool.add_itme(upgrade_axe_damage, 10)


func apply_upgrade(upgrade: AbilityUpgrade) -> void:
	var has_upgrade = current_upgrades.has(upgrade.id)
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1
	
	if upgrade.max_quantity > 0:
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		if current_quantity == upgrade.max_quantity:
			upgrade_pool.remove_item(upgrade)
	
	update_upgrade_pool(upgrade)
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)


func pick_upgrades() -> Array[AbilityUpgrade]:
	var chosen_upgrades: Array[AbilityUpgrade] = []
	upgrade_pool.refresh_pick_items()
	for i in max_pick_card_num:
		var chosen_upgrade: AbilityUpgrade = upgrade_pool.pick_item(true)
		chosen_upgrades.append(chosen_upgrade)
	return chosen_upgrades


func on_upgrade_selected(upgrade: AbilityUpgrade) -> void:
	apply_upgrade(upgrade)


func on_level_up(_current_level: int) -> void:
	var chosen_upgrades: Array = pick_upgrades()
	if chosen_upgrades.size() == 0:
		return
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades as Array[AbilityUpgrade])
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)
