extends Node2D

@onready var ball_and_chain = $"player/ball and chain"
@onready var point = $"player/ball and chain/point"
@onready var ball = $"player/ball and chain/ball"
@onready var player = $player

@onready var line = $Line2D
@onready var line2 = $Line2D2

@export_range(0, 1) var launch_modifier = 0.5
var launch_angle = Vector2(0,0)
var ball_velocity = Vector2(0,0)

func _ready():
	point.mouse_enter = false
	ball_and_chain.visible = false
	ball_and_chain.activated = false

func _physics_process(_delta):
	
	line.clear_points()
	line.add_point( player.position )
	line.add_point( player.position - point.position + ball.position )
	line.global_rotation = 0 #you'll need this because Line2D will rotate together with a body
	
	line2.clear_points()
	line2.add_point( player.position )
	line2.add_point( player.position + launch_angle * 0.01)
	line2.global_rotation = 0 #you'll need this because Line2D will rotate together with a body
