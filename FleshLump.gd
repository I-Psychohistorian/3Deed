extends KinematicBody


var health = 25
var Name = "FleshPool"
var dead = false
var damage = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func take_damage(damage):
	health -= damage
	$HeadSplatter.emitting = true
	die()
	
func die():
	if health <= 0:
		if dead == false:
			dead = true
			$HeadSplatter.emitting = true
			$DeathTimer.start()

func _on_DeathTimer_timeout():
	queue_free()


func _on_Area_body_entered(body):
	if body.is_in_group('Player'):
		body.take_damage(damage)
		body.infection_check()
