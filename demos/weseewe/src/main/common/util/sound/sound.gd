extends Node2D

@onready var jump_a = $JumpA
@onready var jump_b = $JumpB
@onready var color = $Color
@onready var pop = $Pop
@onready var track = $Track


func playJumpA():
	if not Game.data['sound']:
		return

	if not jump_a.playing:
		jump_a.play()


func playJumpB():
	if not Game.data['sound']:
		return
	if not jump_b.playing:
		jump_b.play()


func playColor():
	if not Game.data['sound']:
		return
	if not color.playing:
		color.play()


func playPop():
	if not Game.data['sound']:
		return
	pop.autoplay = true
	pop.play()


func stopPop():
	pop.autoplay = false
	pop.stop()


func playWelcomMusic():
	track.autoplay = true
	track.pitch_scale = 0.5
	track.play()


func playGameStartMusic():
	track.autoplay = true
	track.pitch_scale = 1
	track.play()


func stopTrack():
	track.autoplay = false
	track.stop()

