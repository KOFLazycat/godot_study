extends Node


func parser(command_string: String) -> Command:
	var command_parts: PackedStringArray = command_string.split(" ")
	var command_name_1: String = command_parts[0]
	var command_name_2: String = command_parts[1]
	var command_value: float = command_parts[2].to_float()
	
	match command_name_1:
		"player":
			var player: Player = get_tree().get_first_node_in_group("player")
			if command_name_2 == "health":
				return PlayerCommand.HealthCommand.new(command_value, player)
			elif command_name_2 == "speed":
				return PlayerCommand.SpeedCommand.new(command_value, player)
			else :
				return null
		_ :
			return null
