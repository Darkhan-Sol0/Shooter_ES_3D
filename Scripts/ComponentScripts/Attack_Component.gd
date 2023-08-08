extends Node3D
class_name Attack_Component

@export var startbullet : Marker3D

@export var max_ammo : int = 10
var ammo : int

@export var damage : int = 0
@export var large : float = 100.0
@export var razbros : float = 1
@export var drop : int = 1

@export var shot_coldown : float = 0.1
@export var reload_time : float = 1

enum Type_Fire { SINGLE, AUTO }
@export var type_fire : Type_Fire

var fired : bool = true
var reloaded : bool = true

@export var otdacha : float = 0

func _ready():
	ammo = max_ammo

func fire():
	match type_fire:
		Type_Fire.SINGLE:
			if Input.is_action_just_pressed("LBM"):
				shot()
		Type_Fire.AUTO:
			if Input.is_action_pressed("LBM"):
				shot()

func reload():
	if reloaded and ammo < max_ammo:
		ammo = 0
		reloaded = false
		await get_tree().create_timer(reload_time).timeout
		ammo = max_ammo
		reloaded = true

func shot():
	if fired and ammo > 0:
		ammo -= 1
		fired = false
		for i in drop:
			bullet_func()
		$"../Head".rotation.x = lerp($"../Head".rotation.x, $"../Head".rotation.x + otdacha, 1)
		await get_tree().create_timer(shot_coldown).timeout
		fired = true
		$"../Head".rotation.x = lerp($"../Head".rotation.x, $"../Head".rotation.x - otdacha/2, 1)
	elif ammo <= 0:
		reload()

func bullet_func():
	var bullet_ins = preload("res://Objects/Staff/bullet.tscn").instantiate()
	var theta = randf() * 2 * PI
	var r = randf_range(0, razbros)
	bullet_ins.global_transform = startbullet.global_transform
	bullet_ins.damage = damage
	bullet_ins.apply_central_impulse(Vector3(r * cos(theta), r * sin(theta), -large).rotated(Vector3(1,0,0), startbullet.global_rotation.x).rotated(Vector3(0,1,0), startbullet.global_rotation.y))
	Global.add_child(bullet_ins)
