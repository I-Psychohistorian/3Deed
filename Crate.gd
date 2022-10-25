extends KinematicBody


var Name = "Crate"
var pickup = "Crate"
var health = 40
var dead = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func take_damage(damage):
	health -= damage
	$Hit.play()
	if health <= 0:
		if dead == false:
			dead = true
			$Timer.start()


func _on_Timer_timeout():
	queue_free()
