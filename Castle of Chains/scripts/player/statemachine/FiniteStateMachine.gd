extends Node
class_name StateMachine 

@onready var player: Player = $".."
@onready var animated_sprite_2d: AnimatedSprite2D = $"../AnimatedSprite2D"
@export var initial_state: State = null

@onready var state: State = (func get_initial_state() -> State:
	return initial_state if initial_state != null else get_child(0)
).call()

func _ready() -> void:
	for state_node: State in find_children("*", "State"):
		state_node.finished.connect(_transition_to_next_state)

	await owner.ready
	state.enter("")
	#print(str(state))
	animated_sprite_2d.play(state.play_animation)


func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)


func _process(delta: float) -> void:
	state.update(delta)


func _physics_process(delta: float) -> void:
	state.physics_update(delta)

func _transition_to_next_state(target_state_path: String, data: Dictionary = {}) -> void:
	if not has_node(target_state_path):
		printerr(owner.name + ": Trying to transition to state " + target_state_path + " but it does not exist.")
		return

	var previous_state_path := state.name
	state.exit()
	state = get_node(target_state_path)
	state.enter(previous_state_path, data)
	#print(str(state))
	animated_sprite_2d.play(state.play_animation)

func pause_movement():
	set_physics_process(false)
	await get_tree().create_timer(0.6).timeout
	set_physics_process(true)
	player.room_change = false
