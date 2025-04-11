extends PlayerState

var laying_orient : Dictionary

func enter(previous_state_path: String, data := {}) -> void:
	player.turnable = false
	player.rotation = 0
	if previous_state_path == "BallThrow":
		play_animation = "laying_front"
		laying_orient["facing"] = 1
	else:
		play_animation = "laying"
		laying_orient["facing"] = 2
	#player.carrying(false)
	await get_tree().create_timer(0.6).timeout

func handle_input(event: InputEvent) -> void:
	if event.is_pressed() and player.velocity.x == 0:
		finished.emit(STANDUP, laying_orient)

func physics_update(_delta: float) -> void:
	if player.is_on_floor():
		player.velocity.x = move_toward(player.velocity.x, 0, 5 * player.speed * player.deceleration)
	elif !player.is_on_floor():
		finished.emit(FALLING)
	player.move_and_slide()
