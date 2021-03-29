extends "res://Scripts/Player/StateTemplate.gd"

func HandleInput(host, delta):
	if (int(Input.is_action_pressed("ui_left")) - int(Input.is_action_pressed("ui_right"))) != 0:
		return "Walk"
	if Input.is_action_pressed("attack"):
		return "Attack"
	if Input.is_action_pressed("ui_up"):
		return "Jump"
	if !host.is_on_floor():
		return "Falling"

	
