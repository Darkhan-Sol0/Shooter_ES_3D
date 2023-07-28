extends CharacterBody3D

@onready var HP = $"Label3D"

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var max_hp : int = 100

var real_hp : int

func _ready():
	real_hp = max_hp
	HP.text = str(real_hp)

func take_damage(damage):
	real_hp -= damage
	HP.text = str(real_hp)
	
	if real_hp <= 0:
		HP.text = str("Im DIE")
		await get_tree().create_timer(1).timeout
		queue_free()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
