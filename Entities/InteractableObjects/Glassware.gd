extends KinematicBody

var Name = "Glassware"
var pickup = "Glassware"
var health = 5
var dead = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func take_damage(damage):
	health -= damage
	if health <= 0:
		if dead == false:
			dead = true
			$BreakTimer.start()
			$Break.play()
			$Beaker.visible = false
			$Beaker2.visible = false
			$Glass.visible = false
			$Stir.visible = false
			$BrokenGlass.emitting = true

func _on_BreakTimer_timeout():
	queue_free()
