extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	if player.is_carrying:
		play_animation = "walk_ball"
	else:
		play_animation = "walk"

func physics_update(delta: float) -> void:
	var input_direction_x := Input.get_axis("left", "right")
	if input_direction_x != 0:
		player.velocity.x = move_toward(player.velocity.x, input_direction_x * player.speed, player.speed * player.acceleration)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.speed * player.deceleration)
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	#print(input_direction_x)
	
	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("jump"):
		finished.emit(JUMP)
	elif is_equal_approx(player.velocity.x, 0.0):
		finished.emit(IDLE)
	elif player.in_area_small and !player.is_carrying and Input.is_action_pressed("interact"):
		finished.emit(PICKUP)
	#elif !player.in_area_big:
		#finished.emit(PULLBALL)
