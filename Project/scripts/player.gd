extends CharacterBody2D

@onready var powerup_bar: Node2D = $PowerupBar
@onready var shield_ring: Node2D = $ShieldRing
var safe_position_timer: float = 0.0


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

var respawn_lock := false
var hit_anim_lock := 0.0
var fall_respawn_scheduled := false
var dead := false
var wind_time := 0.0
var wind_noise := 0.0
var wind_force := 180
var wind_direction := 1

var has_double_jump: bool = false
var used_double_jump: bool = false
var shield_tween: Tween = null

var on_ice := false  # ✅ NEW

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var game_over_ui = get_node("../PauseLayer/GameOver")

var last_safe_position: Vector2
var invincible: bool = false
var knockback_lock: float = 0.0


func _ready() -> void:
	last_safe_position = global_position
	last_safe_position = global_position
	powerup_bar.visible = false
	shield_ring.visible = false


func _physics_process(delta):
	if dead:
		return
		
	hit_anim_lock = max(0.0, hit_anim_lock - delta)
	knockback_lock = max(0.0, knockback_lock - delta)


	on_ice = Global.on_ice

	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump + Double Jump
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			$JumpSFX.play()
			used_double_jump = false
		elif has_double_jump and not used_double_jump:
			velocity.y = JUMP_VELOCITY * 0.85   # slightly weaker than normal jump
			used_double_jump = true
			$JumpSFX.play()

# Also reset double jump flag when landing
	if is_on_floor():
		used_double_jump = false

	# Input direction: -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")

	# Flip sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	# Animations
	if hit_anim_lock <= 0.0:
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")
		else:
			animated_sprite.play("jump")

	
	if knockback_lock <= 0.0:
		if direction:
			velocity.x = direction * SPEED
		else:
			var target_speed = direction * SPEED
			if on_ice:
				velocity.x = move_toward(velocity.x, target_speed, SPEED * 0.2)
			else:
				velocity.x = move_toward(velocity.x, target_speed, SPEED)


	# Wind
	if Global.wind_active:
		wind_time += delta
		
		var gust = sin(wind_time * 2.0)
		
		# Small randomness
		wind_noise = lerp(wind_noise, randf_range(-0.2, 0.2), 0.05)
		
		var wind_strength = wind_force * (gust + wind_noise)
		
		# Stronger in air, softer on ground
		if not is_on_floor():
			wind_strength *= 1.4
		else:
			wind_strength *= 0.6
		
		velocity.x += wind_direction * wind_strength * delta

	move_and_slide()
	

	# Save last safe position only when standing on ground
	if is_on_floor():
		var floor_col = get_last_slide_collision()
		if floor_col:
			var collider = floor_col.get_collider()
			if collider is TileMap:
				last_safe_position = global_position


func take_enemy_hit(hit_from_x: float) -> void:
	if invincible:
		return

	# Shield absorbs the hit
	if Global.shield_active:
		_end_shield()
		$HitSFX.play()
		invincible = true
		await get_tree().create_timer(0.6).timeout
		invincible = false
		return

	invincible = true

	if not Global.easy_mode:
		Global.health = 0
		call_deferred("_show_game_over", "enemy")
		return

	_apply_damage()
	animated_sprite.play("hit")
	$HitSFX.play()
	hit_anim_lock = 0.35

	if Global.health <= 0:
		call_deferred("_show_game_over", "enemy")
		return

	global_position = last_safe_position + Vector2(0, -6)
	var knock_dir := -1.0
	if hit_from_x < global_position.x:
		knock_dir = 1.0
	else:
		knock_dir = -1.0
	velocity.x = 220.0 * knock_dir
	velocity.y = -140.0
	knockback_lock = 0.25
	await get_tree().create_timer(0.6).timeout
	invincible = false


func take_fall_damage() -> void:
	if respawn_lock:
		return

	if invincible and fall_respawn_scheduled:
		return

	invincible = true

	if not Global.easy_mode:
		Global.health = 0
		call_deferred("_show_game_over", "fall")
		return

	if not fall_respawn_scheduled:
		fall_respawn_scheduled = true
		#Global.health -= 1
		_apply_damage()

		if Global.health <= 0:
			fall_respawn_scheduled = false
			call_deferred("_show_game_over", "fall")
			return

		call_deferred("_respawn_after_fall")


func _respawn_after_fall() -> void:
	respawn_lock = true
	fall_respawn_scheduled = false

	global_position = last_safe_position + Vector2(0, -8)
	velocity = Vector2.ZERO

	await get_tree().create_timer(0.15).timeout
	respawn_lock = false

	_start_invincibility()


func _start_invincibility() -> void:
	await get_tree().create_timer(0.6).timeout
	invincible = false


func _show_game_over(cause: String) -> void:
	dead = true
	velocity = Vector2.ZERO
	animated_sprite.play("death")

	await get_tree().create_timer(0.5).timeout
	game_over_ui.show_game_over(cause)


func _reload_level() -> void:
	get_tree().reload_current_scene()
	
func activate_double_jump() -> void:
	has_double_jump = true
	Global.double_jump_active = true
	powerup_bar.start(Color(1.0, 0.85, 0.1))   # yellow for grape
	await get_tree().create_timer(8.0).timeout
	has_double_jump = false
	used_double_jump = false
	Global.double_jump_active = false


func activate_shield() -> void:
	if Global.shield_active:
		return
	Global.shield_active = true
	Global.shield_started.emit()
	shield_ring.start()
	powerup_bar.start(Color(0.4, 0.7, 1.0))    # blue for shield
	await get_tree().create_timer(8.0).timeout
	_end_shield()


func _end_shield() -> void:
	Global.shield_active = false
	Global.shield_ended.emit()
	shield_ring.stop()
	# bar will expire on its own, but stop it early if shield was consumed
	powerup_bar.stop()
	animated_sprite.modulate = Color(1, 1, 1, 1)
	
func _apply_damage() -> void:
	if Global.bonus_hearts > 0 and Global.health >= Global.max_health:
		Global.bonus_hearts -= 1
		Global.bonus_heart_consumed.emit()
	else:
		Global.health -= 1
