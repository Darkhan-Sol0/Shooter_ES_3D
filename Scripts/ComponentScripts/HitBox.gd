extends Area3D
class_name Hit_Box

var collis : bool = true
var damage

func _ready():
	body_entered.connect(self._on_body_entered)

func _process(delta):
	$"CollisionShape3D".disabled = collis

func _on_body_entered(cell : Node3D):
	if cell == null:
		return
	
	if cell.has_method("take_damage"):
		cell.take_damage(damage)
