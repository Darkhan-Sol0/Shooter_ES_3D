extends CharacterBody3D

@onready var animation : AnimationTree = $AnimationTree

@onready var camera = $Head/Camera_Player

@export var real_speed : float = 7.0
var speed : float = 0.0
var stop_speed : float

@export var jump : float = 10.0
@export var can_jump : bool = true

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

enum STATUS_MOVEMENT {  run, sprint, walk }
@export var stat_move : STATUS_MOVEMENT

enum STATUS_POSE { stay, seat }
@export var stat_pose : STATUS_POSE

func _ready():
	animation.active = true
	
#	qt_prev = global_transform
#	qt_current = global_transform

#func update_transform():
#	qt_prev = qt_current
#	qt_current = global_transform

func _input(event):
	if event is InputEventMouseMotion:
		var dx = -event.relative.x * 0.0025
		var dy = -event.relative.y * 0.0025
		rotate_y(dx * (Engine.get_frames_per_second()/Engine.physics_ticks_per_second))
		$Head.rotation.x = clamp($Head.rotation.x + dy, -PI/2, PI/2)

func change_movement(CHANGE_MOVE_STATUS):
	stat_move = CHANGE_MOVE_STATUS

func type_movement(delta):
	match stat_move:
		STATUS_MOVEMENT.run:
			speed = snapped(move_toward(speed, real_speed, 20 * delta), 0.001)
			camera.fov = snapped(lerp(camera.fov, 90.0, 0.05), 0.001)
		STATUS_MOVEMENT.sprint:
			speed = snapped(move_toward(speed, real_speed * 1.8, 20 * delta), 0.001)
			camera.fov = snapped(lerp(camera.fov, 110.0, 0.05), 0.001)
		STATUS_MOVEMENT.walk:
			speed = snapped(move_toward(speed, real_speed * 0.3, 20 * delta), 0.001)
			camera.fov = snapped(lerp(camera.fov, 90.0, 0.05), 0.001)

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

func get_gravity(delta):
	if not is_on_floor():
		velocity.y = snapped(lerp(velocity.y, -gravity, 2 * delta), 0.001)
		stop_speed = delta
	else:
		can_jump = true
		stop_speed = 1

func get_movement(delta):
	if Input.is_action_just_pressed("space") and can_jump:
		velocity.y = jump
		can_jump = false

	if (stat_move == STATUS_MOVEMENT.sprint) and ((velocity == Vector3.ZERO) or (not Input.is_action_pressed("move_forward"))):
		change_movement(STATUS_MOVEMENT.run)

	if Input.is_action_just_pressed("ctl"):
		if stat_pose == STATUS_POSE.stay:
			change_pose(STATUS_POSE.seat)
			change_movement(STATUS_MOVEMENT.walk)
		else:
			change_pose(STATUS_POSE.stay)
			change_movement(STATUS_MOVEMENT.run)
	
	if Input.is_action_just_pressed("shift"):
		if stat_move == STATUS_MOVEMENT.run and Input.is_action_pressed("move_forward"):
			change_movement(STATUS_MOVEMENT.sprint)
		else:
			change_movement(STATUS_MOVEMENT.run)
		change_pose(STATUS_POSE.stay)

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = snapped(move_toward(velocity.x, direction.x * speed, speed), 0.001)
		velocity.z = snapped(move_toward(velocity.z, direction.z * speed, speed), 0.001)
		
	else:
		velocity.z = snapped(lerp(velocity.z, 0.0, stop_speed), 0.001)
		velocity.x = snapped(lerp(velocity.x, 0.0, stop_speed), 0.001)

func get_animation():
	if velocity == Vector3.ZERO:
		animation["parameters/conditions/idle"] = true
		animation["parameters/conditions/moving"] = false
	else:
		animation["parameters/conditions/moving"] = true
		animation["parameters/conditions/idle"] = false

func get_input():
	if Input.is_action_pressed("RBM"):
		camera.fov = snapped(lerp(camera.fov, -20.0, 0.05), 0.001)
	else:
		camera.fov = snapped(lerp(camera.fov, 90.0, 0.05), 0.001)

func _physics_process(delta):
	get_gravity(delta)
	get_movement(delta)
#	update = true

	move_and_slide()

func _process(delta):
	get_animation()
	type_movement(delta)
	type_pose(delta)
	get_input()
	
#	if update:
#		update_transform()
#		update = false
#
#	var f = clamp(Engine.get_physics_interpolation_fraction(), 0, 1)
#	global_transform = qt_prev.interpolate_with(qt_current, f)
