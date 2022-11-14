extends CanvasLayer

@onready var wood_label = $WoodLabel
@onready var coin_label = $CoinLabel


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	wood_label.text = "Wood: " + str(Game.Wood)
	coin_label.text = "Coin: " + str(Game.Coin)
