extends Node

onready var fpsLabel = get_node("CanvasLayer/DebugLabel")
export var toggle : bool = true

func _process(delta):
	if toggle:
		# add information to display here
		fpsLabel.set_text("FPS: " + str(Performance.get_monitor(Performance.TIME_FPS)))
		fpsLabel.add_text("\nMemory Static: " + str(round(Performance.get_monitor(Performance.MEMORY_STATIC)/1024/1024)) + " MB")
		fpsLabel.add_text("\nDelta: " + str(delta))
		
		fpsLabel.visible = true
	else:
		fpsLabel.visible = false
	
	if Input.is_action_just_pressed("ui_cancel"):
		toggle = !toggle
