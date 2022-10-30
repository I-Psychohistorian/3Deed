extends KinematicBody

#up elevator
signal call
var Name = "Call elevator"
var active = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func use():
	if active == true:
		active = false
		$OmniLight.visible = true
		$MeshInstance/ButtonPressed.visible = true
		$MeshInstance/ButtunUnpress.visible = false
		$Button.play()
		emit_signal("call")

func _on_Elevator_toggle_call_upper():
	active = true
	$OmniLight.visible = false
	$MeshInstance/ButtonPressed.visible = false
	$MeshInstance/ButtunUnpress.visible = true


func _on_Elevator_toggle_call_basement():
	active = false
	$OmniLight.visible = true
	$MeshInstance/ButtonPressed.visible = true
	$MeshInstance/ButtunUnpress.visible = false
