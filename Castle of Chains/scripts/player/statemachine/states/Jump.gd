extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	if player.is_carrying:
		play_animation = "jump_ball"
	else:
		play_animation = "jump"
	player.velocity.y = player.jump_force
	

func physics_update(delta: float) -> void:
	var input_direction_x := Input.get_axis("left", "right")
	if input_direction_x:
		player.velocity.x = move_toward(player.velocity.x, input_direction_x * player.speed, player.speed * player.acceleration * 0.5)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.speed * player.deceleration)
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	if player.is_on_floor():
		finished.emit(IDLE)
	if player.velocity.y > 0:
		finished.emit(FALLING)
	#elif !player.in_area_big:
		#finished.emit(PULLBALL)
