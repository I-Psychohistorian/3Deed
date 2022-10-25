extends Spatial


var angle_coords_open = Vector3(0, 90, 0)
var angle_coords_closed = Vector3(0, 0, 0)
var open = false
var dead = false

var cooldown = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func door():
	if cooldown == false:
		if open == false:
			rotate_y(deg2rad(90))
			open = true
		elif open == true:
			rotate_y(deg2rad(-90))
			open = false
		$Cooldown.start()
		$Open.play()
		cooldown = true
		

func _on_KeyCardDoor_close():
	door()
	$KeyCardDoor.closed = true


func _on_KeyCardDoor_open():
	door()
	$KeyCardDoor.closed = false


func _on_Cooldown_timeout():
	cooldown = false
