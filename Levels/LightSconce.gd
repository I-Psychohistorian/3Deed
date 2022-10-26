extends MeshInstance

var on = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if on == false:
		$OmniLight.visible = false
		$LightSconce.visible = false
	elif on == true:
		$OmniLight.visible = true
		$LightSconce.visible = true

func _on_Timer1_timeout():
	if on == false:
		on = true
	elif on == true:
		on = false


func _on_Timer2_timeout():
	if on == false:
		on = true
	elif on == true:
		on = false


func _on_Timer3_timeout():
	if on == false:
		on = true
	elif on == true:
		on = false
