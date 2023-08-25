extends RigidBody3D

func _process(delta):
	$OmniLight3D.light_energy -= 0.3 * delta
	if $OmniLight3D.light_energy <= 0:
		queue_free()
