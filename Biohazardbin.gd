extends KinematicBody

var Name = "Open Biohazard Bin"
var active = true
var open = false
onready var radius = $Area

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
			if open == false:
				open = true
				$Lid.visible = false
				$LidOff.visible = true
				Name = "Close Biohazard Bin"
				$Sound.play()
			elif open == true:
				$Sound.play()
				open = false
				$Lid.visible = true
				$LidOff.visible = false
				Name = "Open Biohazard Bin"
