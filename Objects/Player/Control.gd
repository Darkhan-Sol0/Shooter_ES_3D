extends Control


func _process(delta):
	$Label.text = "FPS: " + str(Engine.get_frames_per_second())
	$Label2.text = "PPS: " + str(Engine.physics_ticks_per_second)
