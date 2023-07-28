extends CharacterBody3D

@export var atack_component : Atack_Component

@onready var animation = $"AnimationPlayer"

@export var real_speed : float = 10.0
@export var jump : float = 10.0
@export var can_jump : bool = true
@export var max_hp : int = 100
var real_hp : int
@export var max_stamina : int = 100
var real_stamina : int
var stop_speed : float
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var speed : float = 0.0

var can_atack : bool = true

func _ready():
	real_hp = max_hp
	real_stamina = max_stamina

func _input(event):
	if event is InputEventMouseMotion:
		var dx = -event.relative.x * 0.0025
		var dy = -event.relative.y * 0.0025
		rotate_y(dx)
		$Head.rotation.x = clamp($Head.rotation.x + dy, -PI/2, PI/2)

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

	if Input.is_action_pressed("ctl"):
		$Head.position.y = snapped(lerp($Head.position.y, 1.0, 10.0 * delta), 0.001)
		$CollisionShape3D.shape.height = 1.0
		$CollisionShape3D.position.y = 0.5
		speed = snapped(move_toward(speed, real_speed / 2, 20 * delta), 0.001)
	elif Input.is_action_pressed("shift"):
		speed = snapped(move_toward(speed, real_speed * 1.5, 20 * delta), 0.001)
	else:
		$Head.position.y = snapped(lerp($Head.position.y, 2.0, 10.0 * delta), 0.001)
		$CollisionShape3D.shape.height = 2.0
		$CollisionShape3D.position.y = 1
		speed = snapped(move_toward(speed, real_speed, 20 * delta), 0.001)

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = snapped(move_toward(velocity.x, direction.x * speed, speed), 0.001)
		velocity.z = snapped(move_toward(velocity.z, direction.z * speed, speed), 0.001)
		
	else:
		velocity.z = snapped(lerp(velocity.z, 0.0, stop_speed), 0.001)
		velocity.x = snapped(lerp(velocity.x, 0.0, stop_speed), 0.001)
	
func get_animation():
	if velocity == Vector3(0,0,0):
		animation.play("idle")
	
	if Input.is_action_pressed("move_back") or Input.is_action_pressed("move_right"):
		animation.play("walk")
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_forward"):
		animation.play_backwards("walk")

func get_input():
	if Input.is_action_pressed("LBM") and can_atack:
		can_atack = false
		atack_component.atack()
		can_atack = true

func _physics_process(delta):
	get_animation()
	get_gravity(delta)
	get_movement(delta)
	get_input()

	move_and_slide()
