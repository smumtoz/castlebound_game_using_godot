extends Node

var score = 0
var key = 0

signal score_changed(new_score)
signal key_pickup(key)

func add_point():
	score += 1
	score_changed.emit(score)

func reset():
	score = 0
	key=0
	key_pickup.emit(key)
	score_changed.emit(score)

func add_key():
	key=1
	key_pickup.emit(key)
