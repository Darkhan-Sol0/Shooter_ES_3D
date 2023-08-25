extends StaticBody3D

@onready var light : OmniLight3D = $OmniLight3D

var col = Color(randf(), randf(), randf(), randf())

var a = -1

var i = 1

var mat

var c1 = 1
var c2 = 1
var c3 = 1
var c4 = 1

var fl = true

func _ready():
	mat = StandardMaterial3D.new()
	mat.rim_enabled = true
	mat.albedo_color = Color(1,1,1,1)
	$MeshInstance3D.set_surface_override_material(0, mat)

func _process(delta):
	light.light_energy += a * delta

	if light.light_energy <= 0.2:
		a = 1 * randf_range(0, 1)
	elif light.light_energy >= 0.8:
		a = -1 * randf_range(0, 1)

	i -= 2 * delta
	if i <= 0:
		i = 1
		c1 = randf()
		c2 = randf()
		c3 = randf()
		c4 = randf()
	
	if Input.is_action_just_pressed("RBM"):
		fl = not fl
	
	if fl == true:
		col = Color(lerpf(col.r, c1, delta), lerpf(col.g, c2, delta), lerpf(col.b, c3, delta), lerpf(col.a, c4, delta))
	else:
		col = Color(c1, c2, c3, c4)
	
	mat.albedo_color = col
	
	light.light_color = col
	
	$Label3D.text = str($Label3D.owner.name, " ", col)
	$Label3D.modulate = col
