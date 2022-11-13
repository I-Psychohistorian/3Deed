extends Spatial
var dead = false




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_ArmHitbox_die():
	dead = true
	$ArmHitbox.queue_free()
	$Dust.emitting = true
	$Dust2.play()
	$Death.start()


func _on_WoodGolem_enemy_spotted():
	#print('pinching')
	if dead == false:
		$ArmHitbox.aggro()


func _on_WoodGolem_enemy_lost():
	#print('stopped pinching')
	if dead == false:
		$ArmHitbox.deaggro()


func _on_Death_timeout():
	queue_free()
