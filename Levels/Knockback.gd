extends KinematicBody


var shockwave = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	expand()

func expand():
	if shockwave == true:
		self.scale += Vector3(6, 6, 6)
		#self.scale.x +=9
		#self.scale.y +=9
		#self.scale.z +=9
func blast():
	shockwave = true
	$Timer.start()

func _on_Timer_timeout():
	print(self.scale.x)
	shockwave = false
	queue_free()


func _on_ExplosionManager_boom():
	blast()
