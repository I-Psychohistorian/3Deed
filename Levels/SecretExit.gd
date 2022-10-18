extends CSGBox


var movement = Vector3(0, 0, 5)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_MotherGlorper_death():
	$OpenSesame.play()
	translate(get_transform().basis.xform(movement))
