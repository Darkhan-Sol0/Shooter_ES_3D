extends RigidBody3D

@onready var HP = $"Label3D"

@export var max_hp : int = 100

var real_hp : int

var life : bool = true

func _ready():
	real_hp = max_hp
	HP.text = str(real_hp)
	

func die():
	for i in 10:
		var meet = preload("res://Objects/Staff/meet.tscn").instantiate()
		meet.global_transform = global_transform
		meet.position = position + Vector3(0,1,0)
		meet.rotate(Vector3.UP, randf_range(-180, 180))
		meet.apply_central_impulse(Vector3(randf_range(-5, 5),randf_range(2, 10),randf_range(-5, 5)))
		Global.add_child(meet)
	queue_free()

func take_damage(damage):
	real_hp -= damage
	HP.text = str(real_hp)
	
	if real_hp <= 0 and life:
		life = false
		die()
