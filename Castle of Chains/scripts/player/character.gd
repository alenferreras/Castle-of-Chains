extends RigidBody2D

@onready var ball_and_chain_player = $ball_and_chain_player
@onready var player = $player

func _on_player_ball_carry():
	#print("ball_carry")
	visible = false
	ball_and_chain_player.freeze = true

func _on_player_ball_drop():
	#print("ball_drop")
	visible = true
	ball_and_chain_player.freeze = false

func _on_player_ball_throw(launch_angle: Vector2) -> void:
	visible = true
	print(str(launch_angle))
	print("launch")
	apply_impulse(1000 * launch_angle)
