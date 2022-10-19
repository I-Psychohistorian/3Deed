extends Spatial
#y 0 to y 90

var Name = "Door"
var active = true
var health = 50
# Called when the node enters the scene tree for the first time.
var angle_coords_open = Vector3(0, 90, 0)
var angle_coords_closed = Vector3(0, 0, 0)
var open = false
var dead = false

var cooldown = false

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func use():
	if cooldown == false:
		if open == false:
			rotate_y(deg2rad(90))
			open = true
		elif open == true:
			rotate_y(deg2rad(-90))
			open = false
		$OpenSound.play()
		cooldown = true
		$OpenTimer.start()



func _on_Timer_timeout():
	queue_free()


func _on_KinematicBody_open_space():
	use()


func _on_KinematicBody_hurt_space():
	$BreakSound.play()


func _on_KinematicBody_die_space():
	$Timer.start()
	$Broken.play()


func _on_OpenTimer_timeout():
	cooldown = false
