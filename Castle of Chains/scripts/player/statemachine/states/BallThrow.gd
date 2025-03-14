extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.carrying(false)
	play_animation = "ball_throw"
	#player.visible = false

func physics_update(delta: float) -> void:
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	if player.is_on_floor() and player.velocity.y > 0:
		player.visible = true
		finished.emit(LAYING)
		
	if player.is_on_wall():
		player.visible = true
		finished.emit(FALLING)
	player.move_and_slide()
