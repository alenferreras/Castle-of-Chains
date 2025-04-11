extends CharacterBody2D
class_name Player

#Basic Movement Variables
@export var speed = 180
@export_range(0, 1) var acceleration = 0.1
@export_range(0, 1) var deceleration = 0.2
@export var jump_force = -300.0

#Misc Variables
@onready var animated_sprite = $AnimatedSprite2D
var in_area_small = false
var in_area_big = false
var mouse_enter = false
@onready var ray_cast_2d = $Area2D/RayCast2D
var turnable = true

#Camera Variables
@onready var room_change = false
@onready var prev_room = null
@onready var curr_room = null

#Ball and Chain Variables
@onready var ball_and_chain = $"ball and chain"
@onready var point = $"ball and chain/point"
@onready var ball = $"ball and chain/ball"
var is_carrying = true

#Ball and Chain Movement Variables
@export_range(0, 1) var launch_modifier = 0.5
var launch_angle = Vector2(0,0)
var ball_velocity = Vector2(0,0)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#State Machine
@onready var state_machine = $StateMachine

#Signals
signal ball_carry
signal ball_drop
signal ball_throw(launch_angle : Vector2)

var direction = Input.get_axis("left", "right")

func _ready():
	point.mouse_enter = false
	ball_and_chain.visible = false
	ball_and_chain.activated = false

func _physics_process(delta):
	#default_movement(delta)
	advanced_movement()
	
	#print(velocity)
	#print(velocity.x)
	#print("area small = " + str(in_area_small))
	#print("area big = " + str(in_area_big))
	
	
	#move_and_slide()

func pause_movement():
	set_physics_process(false)
	state_machine.set_physics_process(false)
	state_machine.set_process(false)
	await get_tree().create_timer(0.6).timeout
	set_physics_process(true)
	state_machine.set_physics_process(true)
	state_machine.set_process(true)
	room_change = false

func default_movement(delta: float):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	
	#Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	#Play Animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle_ball")
		else:
			animated_sprite.play("walk_ball")
	else:
		animated_sprite.play("jump_ball")
	
	#Basic Movement
	if direction:
		velocity.x = move_toward(velocity.x, direction * speed, speed * acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, speed * deceleration)
		
	# Ball Throw
	if Input.is_action_just_pressed("interact") and mouse_enter:
		point.mouse_enter = true
		ball_and_chain.visible = true
		ball_and_chain.activated = true
	elif Input.is_action_just_released("interact"):
		velocity = launch_modifier * launch_angle
		point.mouse_enter = false
		ball_and_chain.visible = false
		ball_and_chain.activated = false
	
	ball_velocity = 0.05 * ball.linear_velocity.length()
	launch_angle = (point.position + ball.position) * ball_velocity
	
	move_and_slide()

func advanced_movement():
	var direction = Input.get_axis("left", "right")
	if ray_cast_2d.is_colliding():
		in_area_big = true
	
	if !in_area_big and !is_carrying:
		if !is_on_floor():
			speed = 40
			acceleration = 10
			deceleration = 10
			jump_force = -130.0
		else:
			speed = 10
			acceleration = 10
			deceleration = 10
			jump_force = -130.0
	elif in_area_big and !is_carrying:
		speed = 180
		acceleration = 0.1
		deceleration = 0.2
		jump_force = -300.0
	elif is_carrying:
		speed = 100
		acceleration = 0.075
		deceleration = 0.1
		jump_force = -270.0
	
	#Flip the Sprite
	if turnable:
		if direction > 0:
			animated_sprite.flip_h = false
			ray_cast_2d.target_position = Vector2(40, 0)
		elif direction < 0:
			animated_sprite.flip_h = true
			ray_cast_2d.target_position = -Vector2(40, 0)
		
	if room_change:
		state_machine.pause_movement()

func _on_mouse_entered():
	mouse_enter = true
	
func _on_mouse_exited():
	mouse_enter = false

#Camera stuff
func _on_room_detector_area_entered(area):
	var collision_shape = area.get_node("CollisionShape2D")
	var room_position = area.global_position
	var center = collision_shape.shape.get_rect().position
	var size = collision_shape.shape.get_rect().size
	
	prev_room = curr_room
	curr_room = area
	if prev_room != null and prev_room != curr_room :
		room_change = true
	else:
		pass
	#print("prev" + str(prev_room))
	#print("curr" + str(curr_room))
	#print(center)
	#print(size)
	#print(room_position)
	
	var camera = $Camera2D
	camera.limit_left = center.x + room_position.x
	camera.limit_top = center.y + room_position.y

	camera.limit_right = camera.limit_left + size.x
	camera.limit_bottom = camera.limit_top + size.y
	#print(camera.global_position)

#Ball and Chain stuff
func _on_area_2d_area_entered(area):
	if area.name == "Area_small":
		in_area_small = true
	if area.name == "Area_big":
		in_area_big = true

func _on_area_2d_area_exited(area):
	if area.name == "Area_small":
		in_area_small = false
	if area.name == "Area_big":
		in_area_big = false

func carrying(carry : bool):
	if carry:
		emit_signal("ball_carry")
		is_carrying = true
		speed = 100
		acceleration = 0.075
		deceleration = 0.1
		jump_force = -270.0
	else:
		emit_signal("ball_drop")
		is_carrying = false
		speed = 180
		acceleration = 0.1
		deceleration = 0.2
		jump_force = -300.0
