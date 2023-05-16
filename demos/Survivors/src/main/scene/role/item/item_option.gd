extends ColorRect


@onready var player = get_tree().get_first_node_in_group("player")


var mouse_over: bool = false
var item = null

signal selected_upgrade(upgrade)


func _ready() -> void:
	connect("selected_upgrade", Callable(player, "upgrade_character"))


func _on_mouse_entered() -> void:
	mouse_over = true


func _on_mouse_exited() -> void:
	mouse_over = false


func _input(event: InputEvent) -> void:
	if event.is_action("click"):
		if mouse_over:
			emit_signal("selected_upgrade", item)
