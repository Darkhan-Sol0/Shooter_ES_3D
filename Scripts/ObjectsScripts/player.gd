extends CharacterBody3D

@onready var Head : Node3D = $Head
@onready var Camera : Camera3D = $Head/Camera_Player

@export var jump : float = 5
@export var gravity : float = 10

@export var max_speed : float = 10
@export var acceleration : float = 1
@export var decceleration : float = 1

var real_acceleration : float = 0.0
var real_decceleration : float = 0.0
var real_speed : float = 0.0
var speed : float = 0.0

@export var mouse_sens: float = 0.0025

enum STATUS_MOVEMENT {  run, sprint, walk, fly }
@export var stat_move : STATUS_MOVEMENT

enum STATUS_POSE { stay, seat }
@export var stat_pose : STATUS_POSE

var can_jump : bool = true

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(event.relative.x * -mouse_sens)
		Head.rotation.x = clamp(Head.rotation.x + (event.relative.y * -mouse_sens / 2), -PI/2, PI/2)

func get_gravity(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
		real_decceleration = delta
		real_acceleration = 0.1
		speed = max_speed / 2
	else:
		can_jump = true
		real_decceleration = acceleration
		real_acceleration = decceleration
		speed = max_speed

func change_movement(CHANGE_MOVE_STATUS):
	stat_move = CHANGE_MOVE_STATUS

func type_movement(delta):
	match stat_move:
		STATUS_MOVEMENT.run:
			real_speed = move_toward(real_speed, speed, real_acceleration)
		STATUS_MOVEMENT.sprint:
			real_speed = move_toward(real_speed, speed * 1.8, real_acceleration)
		STATUS_MOVEMENT.walk:
			real_speed = move_toward(real_speed, speed * 0.3, real_acceleration)

func change_pose(CHANGE_POSE_STATUS):
	stat_pose = CHANGE_POSE_STATUS

func type_pose(delta):
	match stat_pose:
		STATUS_POSE.stay:
			$Head.position.y = snapped(lerp($Head.position.y, 2.0, 10.0 * delta), 0.001)
			$CollisionShape3D.shape.height = 2.0
			$CollisionShape3D.position.y = 1
		STATUS_POSE.seat:
			$Head.position.y = snapped(lerp($Head.position.y, 1.0, 10.0 * delta), 0.001)
			$CollisionShape3D.shape.height = 1.0
			$CollisionShape3D.position.y = 0.5

func get_movement(delta):
	if (stat_move == STATUS_MOVEMENT.sprint) and ((velocity == Vector3.ZERO) or (not Input.is_action_pressed("move_forward"))):
		change_movement(STATUS_MOVEMENT.run)
	
	if Input.is_action_just_pressed("space") and can_jump:
		velocity.y = jump
		can_jump = false
	
	if Input.is_action_just_pressed("ctl"):
		if stat_pose == STATUS_POSE.stay:
			change_pose(STATUS_POSE.seat)
		else:
			change_pose(STATUS_POSE.stay)
	
	if Input.is_action_just_pressed("shift"):
		if stat_move == STATUS_MOVEMENT.run and Input.is_action_pressed("move_forward"):
			change_movement(STATUS_MOVEMENT.sprint)
		else:
			change_movement(STATUS_MOVEMENT.run)
		change_pose(STATUS_POSE.stay)
	
	
	var dir_input = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var dir_move = transform.basis * Vector3(dir_input.x, 0, dir_input.y).normalized()
	if dir_move.length() > 0:
		velocity.x = lerp(velocity.x, dir_move.x * real_speed, real_acceleration)
		velocity.z = lerp(velocity.z, dir_move.z * real_speed, real_acceleration)
	else:
		velocity.x = lerp(velocity.x, 0.0, real_decceleration)
		velocity.z = lerp(velocity.z, 0.0, real_decceleration)

func _physics_process(delta):
	get_gravity(delta)
	get_movement(delta)
	type_movement(delta)
	type_pose(delta)

	move_and_slide()
