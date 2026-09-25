extends Node

var easy_mode: bool = true
var health: int = 3
var max_health: int = 3
var coins: int = 0
var coins_since_last_heart: int = 0
var bonus_hearts: int = 0          # stored overflow heart (max 1)
var wind_active = false
var on_ice := false
var hint_shown: bool = false
signal key_collected
signal key_zone_1
signal key_zone_2
signal key_zone_3

# Powerup state
var shield_active: bool = false
var double_jump_active: bool = false

# Powerup hints
var grape_hint_shown: bool = false
var apple_hint_shown: bool = false

signal heart_gained
signal bonus_heart_stored      # fires when overflow heart is banked
signal bonus_heart_consumed    # fires when it gets used on a hit
signal first_coin_hint
signal grape_hint
signal apple_hint
signal shield_started
signal shield_ended

func reset_run() -> void:
	health = 3
	max_health = 3
	coins = 0
	coins_since_last_heart = 0
	bonus_hearts = 0
	shield_active = false
	double_jump_active = false
	hint_shown = false
	grape_hint_shown = false
	apple_hint_shown = false

func add_coin():
	coins += 1
	if easy_mode and not hint_shown:
		hint_shown = true
		first_coin_hint.emit()
	if easy_mode:
		coins_since_last_heart += 1
		if coins_since_last_heart >= 5:
			coins_since_last_heart = 0
			if health < max_health:
				health += 1
				heart_gained.emit()
			elif bonus_hearts < 1:
				bonus_hearts += 1
				bonus_heart_stored.emit()

func reset_coins():
	coins = 0
	coins_since_last_heart = 0
