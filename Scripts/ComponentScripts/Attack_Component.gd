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

enum Type_Bullet { RAY, BULLET }
@export var type_bullet : Type_Bullet

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
		$"../Head".rotation.x = lerp($"../Head".rotation.x, $"../Head".rotation.x + otdacha, 0.1)
		await get_tree().create_timer(shot_coldown).timeout
		fired = true
		$"../Head".rotation.x = lerp($"../Head".rotation.x, $"../Head".rotation.x - otdacha/2, 0.1)
	elif ammo <= 0:
		reload()

func bullet_func():
	match type_bullet:
		Type_Bullet.BULLET:
			var bullet_ins = preload("res://Objects/Staff/bullet.tscn").instantiate()
			var theta = randf() * 2 * PI
			var r = randf_range(0, razbros)
			bullet_ins.global_transform = startbullet.global_transform
			bullet_ins.rotation.z = randf_range(0, PI)
			bullet_ins.damage = damage
			bullet_ins.apply_central_impulse(Vector3(r * cos(theta), r * sin(theta), -large).rotated(Vector3(1,0,0), startbullet.global_rotation.x).rotated(Vector3(0,1,0), startbullet.global_rotation.y))
			Global.add_child(bullet_ins)
		Type_Bullet.RAY:
			var bullet_ins = RayCast3D.new()
			var r = randf_range(-razbros, razbros)
			bullet_ins.target_position = Vector3(0, r, -large)
			bullet_ins.global_transform = startbullet.global_transform
			bullet_ins.rotation.z = randf_range(0, 2*PI)
			Global.add_child(bullet_ins)
			await get_tree().create_timer(0.1).timeout
			if bullet_ins.is_colliding():
				if bullet_ins.get_collider().has_method("take_damage"):
					bullet_ins.get_collider().take_damage(damage)
			await get_tree().create_timer(0.2).timeout
			get_tree().queue_delete(bullet_ins)

