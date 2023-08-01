extends Node3D
class_name InterpolatedTransform

var update = false
var qt_prev : Transform3D
var qt_current : Transform3D

func _ready():
	set_as_top_level(true)

	qt_prev = owner.global_transform
	qt_current = owner.global_transform

func update_transform():
	qt_prev = qt_current
	qt_current = owner.global_transform

func _process(delta):
	if update:
		update_transform()
		update = false

	var f = clamp(Engine.get_physics_interpolation_fraction(), 0, 1)
	owner.global_transform = qt_prev.interpolate_with(qt_current, f)

func _physics_process(delta):
	update = true
