extends Node3D
class_name Movement_Component

func get_movement(delta):
	if Input.is_action_just_pressed("space") and owner.can_jump:
		owner.velocity.y = owner.jump
		owner.can_jump = false
	
	var dir_input = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var dir_move = owner.transform.basis * Vector3(dir_input.x, 0, dir_input.y).normalized()
	if dir_move.length() > 0:
		owner.velocity.x = lerp(owner.velocity.x, dir_move.x * owner.real_speed, owner.real_acceleration)
		owner.velocity.z = lerp(owner.velocity.z, dir_move.z * owner.real_speed, owner.real_acceleration)
	else:
		owner.velocity.x = lerp(owner.velocity.x, 0.0, owner.real_decceleration)
		owner.velocity.z = lerp(owner.velocity.z, 0.0, owner.real_decceleration)
