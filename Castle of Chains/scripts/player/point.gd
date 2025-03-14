extends CharacterBody2D

@export var speed = 200
var click_position = Vector2()
var target_position = Vector2()
@export var mouse_enter = false

func _ready():
	click_position = global_position

func _physics_process(_delta):
	if Input.is_action_pressed("interact") and mouse_enter:
		click_position = get_global_mouse_position()
		
		if global_position.distance_to(click_position) > 1:
			target_position = (click_position - global_position).normalized()
			velocity = lerp(velocity, target_position * speed, 0.5)
			move_and_slide()
		
		elif global_position.distance_to(click_position) <= 1:
			target_position = (click_position - global_position)
			velocity = lerp(velocity, target_position * speed * 0.75, 0.5)
			move_and_slide()
			
		#elif is_equal_approx(0, global_position.distance_to(click_position)):
			
			
	else:
		velocity = Vector2.ZERO
