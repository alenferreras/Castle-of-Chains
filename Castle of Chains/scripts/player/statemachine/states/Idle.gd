extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.turnable = true
	if player.is_carrying:
		play_animation = "idle_ball"
	else:
		play_animation = "idle"

func physics_update(_delta: float) -> void:
	var input_direction_x := Input.get_axis("left", "right")
	player.velocity.x = move_toward(player.velocity.x, 0, player.speed * player.deceleration)
	player.velocity.y += player.gravity * _delta
	player.move_and_slide()
	
	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("jump"):
		finished.emit(JUMP)
	elif input_direction_x != 0 and (Input.is_action_pressed("left") or Input.is_action_pressed("right")):
		finished.emit(WALK)
	elif player.in_area_small and !player.is_carrying and Input.is_action_pressed("interact"):
		finished.emit(PICKUP)
	elif Input.is_action_just_pressed("interact") and player.mouse_enter and player.is_carrying:
		finished.emit(BALLSPIN)
