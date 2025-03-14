extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	play_animation = "pick_up"
	player.carrying(true)
	await get_tree().create_timer(0.5).timeout
	finished.emit(IDLE)

func physics_update(_delta: float) -> void:
	player.velocity.x = move_toward(player.velocity.x, 0, player.speed * player.deceleration)
	player.move_and_slide()
