extends Node3D
class_name Atack_Component



@export var hitbox : Node3D
@export var damage : int = 0
@export var atack_speed : float = 1

func atack():
	if hitbox != null:
		hitbox.damage = damage
