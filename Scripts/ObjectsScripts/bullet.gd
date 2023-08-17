extends RigidBody3D

var damage

func _ready():
	body_entered.connect(self._on_body_entered)

func _on_body_entered(cell : Node3D):
	if cell == null:
		return
	
	if cell == self:
		return
	
	if cell.has_method("take_damage"):
		cell.take_damage(damage)
	
	$OmniLight3D.light_energy = 1

func _process(delta):
	if $OmniLight3D.light_energy > 0.1:
		$OmniLight3D.light_energy -= delta
	await get_tree().create_timer(2).timeout
	queue_free()
