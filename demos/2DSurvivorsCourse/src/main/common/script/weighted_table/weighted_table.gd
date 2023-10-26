class_name WeightedTable

var items: Array[Dictionary] = []
var pick_items: Array[Dictionary] = []
var weight_sum: int = 0
var pick_weight_sum: int = 0


func add_itme(item: Variant, weight: int) -> void:
	items.append({
		"item": item, 
		"weight": weight
	})
	weight_sum += weight


func recalculate_weight_sum() -> void:
	weight_sum = 0
	for item in items:
			weight_sum += item["weight"]

func remove_item(item_to_remove: Variant) -> void:
	items = items.filter(func (item): return item["item"] != item_to_remove)
	recalculate_weight_sum()


# 刷新选取数组
func refresh_pick_items() -> void:
	pick_items = items.duplicate()
	pick_weight_sum = weight_sum


func pick_item(is_exclude: bool = false) -> Variant:
	if pick_weight_sum > 0:
		var chosen_weight: int = randi_range(1, pick_weight_sum)
		var iteration_sum: int = 0
		for item in pick_items:
			iteration_sum += item["weight"]
			if chosen_weight <= iteration_sum:
				if is_exclude:
					pick_items.erase(item)
					pick_weight_sum = pick_weight_sum - item["weight"]
				return item["item"]
	return null
