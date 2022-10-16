extends CSGBox


#y = 0.387 is destination, y = -5.387 starting point

var moving = false
var placed = false
var dest = Vector3(-13.596, 0.387, 21.303)
var y_inc = 0.5
var y_start = -5.387

var count = 101

var movement = Vector3(0, 0.05, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	print(transform.basis.y)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_Magic_Zone_1_body_entered(body):
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
