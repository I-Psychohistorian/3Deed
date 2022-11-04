extends KinematicBody


var Name = "Flip switch down"
var active = true
var up = true
signal case_on
signal case_off
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func use():
	if up == true:
		up = false
		emit_signal("case_off")
		Name = "Flip switch up"
		$SwitchUp.visible = false
		$SwitchDown.visible = true
	elif up == false:
		up = true
		emit_signal("case_on")
		Name = "Flip switch down"
		$SwitchDown.visible = false
		$SwitchUp.visible = true
	$Flip.play()
