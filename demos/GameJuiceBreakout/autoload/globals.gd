extends Node

enum BUMP {
	TOO_FAR,
	EARLY,
	LATE,
	PERFECT
}

var stats = {
	"time": 0.0,
	"bumps_early": 0,
	"bumps_late": 0,
	"bumps_perfect": 0,
	"ball_bounces": 0,
	"score": 0,
}

var camera: Camera2D

func _ready() -> void:
	pass

func reset_stats() -> void:
	for key in stats.keys():
		stats[key] = 0
