extends Node3D
class_name IterpolatedTransform

var iterpolation_time : float = 0.0
var transforms := []
var parent : Node3D

func _ready():
	parent = get_parent_node_3d()
	transforms = [parent.global_transform, parent.global_transform]
	set_as_top_level(true)

func _physics_process(delta):
	iterpolation_time = 0.0
	transforms.push_back(parent.global_transform)
	transforms.pop_front()

func _process(delta):
	iterpolation_time += delta
	
	var old_transform : Transform3D = transforms[transforms.size() - 2]
	var new_transform : Transform3D = transforms[transforms.size() - 1]
	
	var it : float = iterpolation_time * Engine.physics_ticks_per_second
	
	global_transform = old_transform.interpolate_with(new_transform, it)
