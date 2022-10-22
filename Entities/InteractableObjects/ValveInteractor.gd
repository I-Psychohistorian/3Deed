extends KinematicBody

var Name = "Loosen Valve"
var active = true
var tight = true
onready var radius = $Area
signal tighten
signal loosen
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func use():
	var bodies = radius.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group('Player'):
			if tight == true:
				tight = false
				emit_signal("loosen")
				Name = "Tighten Valve"
			elif tight == false:
				tight = true
				emit_signal("tighten")
				Name = "Loosen Valve"
