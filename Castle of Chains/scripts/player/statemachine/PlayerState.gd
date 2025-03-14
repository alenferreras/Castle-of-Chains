extends State
class_name PlayerState 

const IDLE = "Idle"
const WALK = "Walk"
const JUMP = "Jump"
const FALLING = "Falling"
const LAYING = "Laying"
const STANDUP = "Standup"
const PULLBALL = "PullBall"
const PICKUP = "PickUp"
const BALLSPIN = "BallSpin"
const BALLTHROW = "BallThrow"
const HANGING = "Hanging"
const CHAINCLIMB = "ChainClimb"
const DEATH = "Death"
const RESPAWN = "Respawn"

var player: Player

func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null, "The PlayerState state type must be used only in the player scene. It needs the owner to be a Player node.")
