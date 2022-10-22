extends Spatial

var exploded = false
var gasleak = false
signal lit_gas
var damage = 120
signal boom
signal muzzle_light


onready var gasexplosion = preload("res://Effects/Gasfirebody.tscn")
onready var explosion_radius = $Explosion
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_OxygenTank_explode():
	emit_signal('boom')
	exploded = true
	var bodies = explosion_radius.get_overlapping_bodies()
	var fire = gasexplosion.instance()
	self.add_child(fire)
	gasleak = false
	for body in bodies:
		if body.is_in_group('Player'):
			var knockback = body.global_transform.origin
			body.take_damage(damage)
		elif body.is_in_group('Enemy'):
			body.take_damage(damage)
		elif body.is_in_group('Destructible'):
			body.take_damage(damage)


func _on_Player_gunshot():
	if gasleak == true:
		var bodies = explosion_radius.get_overlapping_bodies()
		for body in bodies:
			if body.is_in_group('Player'):
				body.take_damage(10)
				body.muzzle_fire()
				emit_signal("lit_gas")


func _on_OxygenTank_leak_stopped():
	gasleak = false
	print ('gas stopped')

func _on_OxygenTank_leaking():
	gasleak = true
	print('gas started')
