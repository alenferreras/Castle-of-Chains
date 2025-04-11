extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	play_animation = "ball_throw"
	player.turnable = false
	#player.carrying(false)
	#player.visible = false

func physics_update(delta: float) -> void:
	player.velocity.y += player.gravity * delta
	if player.velocity.x < 0:
		player.animated_sprite.flip_h = true
		player.rotation = player.velocity.angle() - PI 
	else:
		player.animated_sprite.flip_h = false
		player.rotation = player.velocity.angle() 
		
	
	player.move_and_slide()
	
	if player.is_on_floor():
		finished.emit(LAYING)
		
	if player.is_on_wall():
		player.velocity.x = -player.get_real_velocity().x * 0.5
		player.velocity.y = player.get_real_velocity().y * 0.5
		finished.emit(FALLING)
		
	if player.is_on_ceiling():
		player.velocity.y = -player.get_real_velocity().y * 0.5
		player.velocity.x = player.get_real_velocity().x 
		finished.emit(FALLING)
