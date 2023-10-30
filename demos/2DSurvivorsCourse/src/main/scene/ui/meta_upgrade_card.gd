extends PanelContainer

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	gui_input.connect(on_gui_input)


func set_meta_upgrade(upgrade: MetaUpgrade) -> void:
	name_label.text = upgrade.name
	description_label.text = upgrade.description



func select_card() -> void:
	animation_player.play("selected")


func on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		select_card()
