extends RigidBody3D

#---Onloade Nodes---
@onready var Head : Node3D = $Head
@onready var Camera : Camera3D = $Head/Camera_Player
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

#---Physics settings---
var gravity : float = 10.0
var is_on_floor : bool = false


func _ready():
	angular_damp = Engine.physics_ticks_per_second/2

func _is_on_floor(state):
	is_on_floor = false
	for i in get_contact_count():
		var cont = state.get_contact_local_normal(i)
		if cont.angle_to(Vector3.UP) <= 46 * (PI/180):
			is_on_floor = true
	return is_on_floor

func _input(event) -> void:
	if event is InputEventMouseMotion:
		dx = -event.relative.x * mouse_sens
		dy = -event.relative.y * mouse_sens
		Head.rotation.y = Head.rotation.y + dx
		Camera.rotation.x = clamp(Camera.rotation.x + dy, -PI/2, PI/2)

func get_movement() -> void:
	if Input.is_action_just_pressed("space") and is_on_floor:
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
	

func _integrate_forces(state):
	print_debug(_is_on_floor(state))
