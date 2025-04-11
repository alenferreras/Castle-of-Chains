extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.visible = true
	if data.get("facing") == 1:
		play_animation = "standup2"
	else: 
		play_animation = "standup"
	await get_tree().create_timer(0.75).timeout
	finished.emit(IDLE)

func physics_update(_delta: float) -> void:
	player.move_and_slide()
