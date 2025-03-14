extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	play_animation = "pull_back"
	var input_direction_x := Input.get_axis("left", "right")
	player.velocity.x = move_toward(player.velocity.x, -input_direction_x * 20, 20)

func physics_update(delta: float) -> void:
	#var input_direction_x := Input.get_axis("left", "right")
	#player.velocity.x = move_toward(player.velocity.x, -input_direction_x * 5000, 200)
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	exit()
	
func exit():
	await get_tree().create_timer(0.3).timeout
	finished.emit(IDLE)
