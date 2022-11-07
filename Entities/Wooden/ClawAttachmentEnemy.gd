extends Spatial


var pinchy = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func pinch():
	if pinchy == false:
		pinchy = true
		$ArmHitbox.aggro()
	elif pinchy == true:
		pinchy = false
		$ArmHitbox.deaggro()

func _on_ArmHitbox_die():
	$ArmHitbox.queue_free()
	$Dust.emitting = true
	$Dust2.play()
	$Death.start()


func _on_WoodGolem_enemy_spotted():
	pinch()


func _on_WoodGolem_enemy_lost():
	pinch()


func _on_Death_timeout():
	queue_free()
