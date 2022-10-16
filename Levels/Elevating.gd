extends CSGCylinder

# target coords = -56.366, -1.316, 16.877
var moving = false
var placed = false
#coords for y start at -10
var y_inc = 0.5
var y_start = -5.387

var count = 101

var movement = Vector3(0, 0.1, 0)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Magic_Zone_Exit_body_entered(body):
	if placed == false:
		if body.is_in_group("Player"):
			moving = true
			$Timer.start()


func _on_Timer_timeout():
	if count > 0:
		count -= 1
		translate(get_transform().basis.xform(movement))
		$Move.play()
		$Timer.start()
		print(count)
	elif count == 0:
		placed = true
