extends Node

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Engine.max_fps = 0

func _input(event):
	if Input.is_action_just_pressed('esc'):
		get_tree().quit()
	
	if Input.is_action_just_pressed("enter"):
		for i in 10:
			var pop = preload("res://Objects/Enemy/rb_enemy.tscn").instantiate()
			pop.global_transform = Transform3D().basis
			pop.global_position = Vector3(randi_range(10, 50),1,randi_range(10, 50))
			
			add_child(pop)
	
	if Input.is_action_just_pressed("ctl"):
		for i in 10:
			var pop = preload("res://Objects/Enemy/enemy.tscn").instantiate()
			pop.global_transform = Transform3D()
			pop.global_position = Vector3(randi_range(10, 50),1,randi_range(10, 50))
			
			add_child(pop)

