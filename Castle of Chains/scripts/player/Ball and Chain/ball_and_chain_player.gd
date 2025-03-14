extends RigidBody2D

@onready var player = $"../player"
@onready var ball = $ball

func _on_player_ball_carry():
	#print("ball_carry")
	visible = false
	ball.freeze = true

func _on_player_ball_drop():
	#print("ball_drop")
	visible = true
	ball.freeze = false

func _on_player_ball_throw(launch_angle: Vector2) -> void:
	print(str(launch_angle))
	#ball.apply_impulse(1000 * launch_angle)
