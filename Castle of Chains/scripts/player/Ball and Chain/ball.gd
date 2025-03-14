extends RigidBody2D

@export var queue_reset: bool = false
@onready var ball_and_chain = $".."

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if ball_and_chain.activated == false:
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0
		position = Vector2(0, 50)
		queue_reset = false
