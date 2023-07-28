extends RigidBody3D

@export var damage : int = 10
@export var collision : bool = true

@onready var coll = $CollisionShape3D


func _ready():
	body_entered.connect(self._on_body_entered)

func _on_body_entered(cell : Node3D):
	if cell == null:
		return
	
	if cell.has_method("take_damage"):
		cell.take_damage(damage)

func _process(delta):
	coll.disabled = collision
	
	position
