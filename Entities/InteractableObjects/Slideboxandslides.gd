extends KinematicBody


var Name = "Adjust slide onto stage"
var active = true

var placed = false

signal placed
signal removed

onready var radius = $Slide_interact
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
			if placed == false:
				placed = true
				emit_signal("placed")
				$moveslide.play()
				Name = "Remove slide from stage"
			elif placed == true:
				placed = false
				$moveslide.play()
				emit_signal("removed")
				Name = "Adjust slide onto stage"
