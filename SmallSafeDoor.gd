extends KinematicBody


var Name = "Small unlocked safe"
var active = true
var open = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func use():
	if open == true:
		rotate_y(deg2rad(90))
		open = false
	elif open == false:
		rotate_y(deg2rad(-90))
		open = true
	$AudioStreamPlayer3D.play()
