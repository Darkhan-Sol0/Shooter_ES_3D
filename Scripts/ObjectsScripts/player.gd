extends CharacterBody3D

@onready var Head : Node3D = $Head
@onready var Camera : Camera3D = $Head/Camera_Player
@onready var HeadCast : Node3D = $HeadCast

@onready var Attack : Attack_Component = $Attack_Component
@onready var Movement : Movement_Component = $Movement_Component

@export var jump : float = 5 
@export var gravity : float = 10

@export var max_speed : float = 7
@export var acceleration : float = 1
@export var decceleration : float = 1

var real_acceleration : float = 0.0
var real_decceleration : float = 0.0
var real_speed : float = 0.0
var speed : float = 0.0

@export var mouse_sens: float = 0.0025


var can_jump : bool = true

var FOV_c : float = 75.0

func _ready():
	real_speed = max_speed
	real_acceleration = acceleration
	real_decceleration = decceleration

func get_head_collide():
	for cast in HeadCast.get_children():
		if cast.is_colliding():
			return false
		else: 
			pass
	return true

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(event.relative.x * -mouse_sens)
		Head.rotation.x = clamp(Head.rotation.x + (event.relative.y * -mouse_sens / 2), -PI/2, PI/2)

func get_gravity(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
		real_decceleration = delta
		real_acceleration = 0.1
		speed = max_speed * 0.2
	else:
		can_jump = true
		real_decceleration = acceleration
		real_acceleration = decceleration
		speed = max_speed

func get_input(delta):
	Attack.fire()

func _physics_process(delta):
	get_gravity(delta)
	Movement.get_movement(delta)

	move_and_slide()

func _process(delta):
	get_input(delta)
	
	HeadCast.position = Head.position
