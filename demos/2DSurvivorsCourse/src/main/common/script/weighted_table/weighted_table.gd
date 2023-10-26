class_name WeightedTable

var items: Array[Dictionary] = []
var weight_sum: int = 0


func add_itme(item: Variant, weight: int) -> void:
	items.append({
		"item": item, 
		"weight": weight
	})
	weight_sum += weight


func pick_item() -> Variant:
	if weight_sum > 0:
		var chosen_weight: int = randi_range(1, weight_sum)
		var iteration_sum: int = 0
		for item in items:
			iteration_sum += item["weight"]
			if chosen_weight <= iteration_sum:
				return item["item"]
	return null
