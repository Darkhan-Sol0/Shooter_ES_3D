extends Node

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
#	Engine.max_fps = 60

func _input(event):
	if Input.is_action_just_pressed('esc'):
		get_tree().quit()
