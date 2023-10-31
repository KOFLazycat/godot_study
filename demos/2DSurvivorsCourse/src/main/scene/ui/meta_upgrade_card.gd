extends PanelContainer

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var purchase_button: Button = %PurchaseButton
@onready var progress_label: Label = %ProgressLabel
@onready var count_label: Label = %CountLabel

var upgrade_info: MetaUpgrade


func _ready() -> void:
	gui_input.connect(on_gui_input)
	purchase_button.pressed.connect(on_purchase_pressed)


func set_meta_upgrade(upgrade: MetaUpgrade) -> void:
	upgrade_info = upgrade
	name_label.text = upgrade.title
	description_label.text = upgrade.description
	update_progress()


func update_progress() -> void:
	var current_quantity: int = 0
	if MetaProgression.save_data["meta_upgrades"].has(upgrade_info.id):
		current_quantity = MetaProgression.save_data["meta_upgrades"][upgrade_info.id]["quantity"]
	var currency = MetaProgression.save_data["meta_upgrade_currency"]
	var percent: float = MetaProgression.save_data["meta_upgrade_currency"] / upgrade_info.experience_cost
	var is_max: bool = (current_quantity >= upgrade_info.max_quantity)
	percent = min(percent, 1)
	progress_bar.value = percent
	purchase_button.disabled = (percent < 1 || is_max)
	if is_max:
		purchase_button.text = "Max"
	progress_label.text = str(currency) + "/" + str(upgrade_info.experience_cost)
	count_label.text = "x%d" % MetaProgression.save_data["meta_upgrades"][upgrade_info.id]["quantity"]


func select_card() -> void:
	animation_player.play("selected")


func on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		select_card()


func on_purchase_pressed() -> void:
	if upgrade_info == null:
		return
	MetaProgression.add_meta_upgrade(upgrade_info)
	MetaProgression.save_data["meta_upgrade_currency"] -= upgrade_info.experience_cost
	MetaProgression.save_file()
	get_tree().call_group("meta_upgrade_card", "update_progress")
	animation_player.play("selected")
