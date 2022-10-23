extends Spatial


var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	#print($RespawnTimer.wait_time)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_RespawnTimer_timeout():
	$AbsorbArea.activated = true
	self.visible = true
	

func _on_AbsorbArea_body_entered(body):
	if body.is_in_group('Tripod'):
		body.target_chosen = false
		body.health += 1
		$AbsorbArea.activated = false
		self.visible = false
		rng.randomize()
		var newtime = rng.randi_range(4,20)
		#print(newtime)
		$RespawnTimer.wait_time = newtime
		$RespawnTimer.start()
