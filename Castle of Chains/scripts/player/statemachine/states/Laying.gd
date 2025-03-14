extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	play_animation = "laying"
	#player.carrying(false)
	await get_tree().create_timer(0.6).timeout

func handle_input(event: InputEvent) -> void:
	if event.is_pressed() and player.velocity.x == 0:
		finished.emit(STANDUP)

func physics_update(_delta: float) -> void:
	if player.is_on_floor():
		player.velocity.x = move_toward(player.velocity.x, 0, 5 * player.speed * player.deceleration)
	elif !player.is_on_floor():
		finished.emit(FALLING)
	player.move_and_slide()
