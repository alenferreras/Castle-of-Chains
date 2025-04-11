extends PlayerState

var fastfall : bool
var prev_state : String

func enter(previous_state_path: String, data := {}) -> void:
	#print("fall")
	player.rotation = 0
	player.turnable = true
	fastfall = false
	if previous_state_path == "Jump" or previous_state_path == "Walk":
		if player.is_carrying:
			play_animation = "airborne_ball"
		else:
			play_animation = "airborne"
	else:
		play_animation = "falling"
	prev_state = previous_state_path

func physics_update(delta: float) -> void:
	var input_direction_x := Input.get_axis("left", "right")
	if input_direction_x:
		player.velocity.x = move_toward(player.velocity.x, input_direction_x * player.speed, player.speed * player.acceleration * 0.5)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.speed * player.deceleration * 0.5)
	player.velocity.y += player.gravity * delta
	
	player.move_and_slide()
	
	if player.velocity.length() > 450:
		fastfall = true
		
	if player.is_on_floor():
		if fastfall or prev_state == "BallSpin" or prev_state == "BallThrow":
			finished.emit(LAYING)
		else:
			finished.emit(IDLE)
	
