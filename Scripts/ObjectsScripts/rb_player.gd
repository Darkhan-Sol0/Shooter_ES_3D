extends RigidBody3D

#---Onloade Nodes---
@onready var Head : Node3D = $Head
@onready var Camera : Camera3D = $Head/Camera_Player
@onready var FloorDetect : Node3D = $FloorDetect
@onready var Attack : Attack_Component = $Attack_Component

#---Movement settings---
@export_group("Movement Settings")
@export var speed : float = 10.0
@export var jump : float = 5.0
@export var acceleration : float = 10
@export var decceleration : float = 10

#---Mouse settings---
@export var mouse_sens : float = 0.0025
var dx : float
var dy : float

var gravity = 10

func _ready():
	angular_damp = Engine.physics_ticks_per_second/2

func _input(event) -> void:
	if event is InputEventMouseMotion:
		dx = -event.relative.x * mouse_sens
		dy = -event.relative.y * mouse_sens
		Head.rotation.y = Head.rotation.y + dx
#		rotate_y(dx)
#		angular_velocity.y = dx
		Camera.rotation.x = clamp(Camera.rotation.x + dy, -PI/2, PI/2)

func is_on_floor() -> bool:
	for i in FloorDetect.get_children():
		if i.is_colliding():
			return true
		else:
			pass
	return false

func get_movement() -> void:
	if Input.is_action_just_pressed("space") and is_on_floor():
		linear_velocity.y = jump
	
	var dir_input = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var move_dir = (Head.transform.basis * Vector3(dir_input.x, 0, dir_input.y)).normalized()
	if move_dir:
		linear_velocity.x = lerp(linear_velocity.x, move_dir.x * speed, acceleration * 0.1)
		linear_velocity.z = lerp(linear_velocity.z, move_dir.z * speed, acceleration * 0.1)
	else: 
		linear_velocity.x = lerp(linear_velocity.x, 0.0, decceleration * 0.1)
		linear_velocity.z = lerp(linear_velocity.z, 0.0, decceleration * 0.1)

func get_input():
	Attack.fire()

func _physics_process(delta):
	get_movement()
	get_input()
