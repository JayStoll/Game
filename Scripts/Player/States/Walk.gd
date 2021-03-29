extends "res://Scripts/Player/StateTemplate.gd"

func HandleInput(host, delta):
	var horizontalMovement = (int(Input.is_action_pressed("ui_right")) 
							- int(Input.is_action_pressed("ui_left")))
	velocity.x = horizontalMovement
	velocity.y = GLOBALS.GRAVITY
	host.move_and_slide(velocity * GLOBALS.PLAYER_SPEED, GLOBALS.FLOOR)
	if Input.is_action_pressed("ui_up"):
		return "Jump"
	# go back to idle state if we are not moving and not in the air
	if horizontalMovement == 0 && host.is_on_floor():
		return "Idle"

