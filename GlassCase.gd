extends Spatial





# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func open():
	$HingePoint.rotate_z(deg2rad(-90))
	$Open.play()

func close():
	$HingePoint.rotate_z(deg2rad(90))
	$Close.play()

func _on_Lid_break_lid():
	$Break.play()


func _on_Lid_close_case():
	close()


func _on_Lid_open_case():
	open()
