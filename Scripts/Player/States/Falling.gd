extends "res://Scripts/Player/StateTemplate.gd"


func HandleInput(host, delta):
	velocity.y += GLOBALS.GRAVITY
	host.move_and_slide(velocity * GLOBALS.PLAYER_SPEED, GLOBALS.FLOOR)
	if host.is_on_floor():
		# check for movement and go to right state
		return "Idle"
	
