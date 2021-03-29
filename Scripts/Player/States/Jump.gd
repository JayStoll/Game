extends "res://Scripts/Player/StateTemplate.gd"


# to jump upwards - this value must be negative
const JUMP_POWER : int = -355

func HandleInput(host, delta):
	velocity.y = JUMP_POWER
	host.move_and_slide(velocity.normalized(), GLOBALS.FLOOR)
	return "Falling"
	
	
