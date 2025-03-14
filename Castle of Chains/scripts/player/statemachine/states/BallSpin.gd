extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	play_animation = "ball_spin"

func physics_update(_delta: float) -> void:
	player.ball_velocity = 0.04 * player.ball.linear_velocity.length()
	player.launch_angle = (player.point.position + player.ball.position) * player.ball_velocity
	player.point.mouse_enter = true
	player.ball_and_chain.visible = true
	player.ball_and_chain.activated = true
	
	if Input.is_action_just_released("interact"):
		player.velocity = player.launch_modifier * player.launch_angle
		player.point.mouse_enter = false
		player.ball_and_chain.visible = false
		player.ball_and_chain.activated = false
		player.ball_throw.emit(player.launch_angle)
		if player.ball_velocity < 10:
			finished.emit(IDLE)
		else:
			finished.emit(FALLING)
