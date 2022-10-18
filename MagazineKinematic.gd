extends KinematicBody


var Name = "Ammo"
var pickup = "Handgun"
onready var radius = $PickupArea
var active = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func use():
	var bodies = radius.get_overlapping_bodies()
	for n in bodies:
		if n.is_in_group("Player"):
			n.ammo += 12
			n.PickupSound()
			queue_free()
