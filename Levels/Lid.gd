extends RigidBody


var active = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func activate():
	print('lid dropped')
	active = true
	$CollisionShape.disabled = false
	self.mode = RigidBody.MODE_RIGID
	$Timer.start()

func _on_Area_body_entered(body):
	if active == true:
		$Thunk.play()


func _on_Timer_timeout():
	queue_free()
