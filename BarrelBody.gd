extends KinematicBody


var health = 20
var Name = "Barrel"
var dead = false

signal wood_break 
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dead == false:
		if health <= 0:
			dead = true
			die()
			
func take_damage(incoming_damage):
	health -= incoming_damage
	print('Ouch!')
	emit_signal("wood_break")
	
	
func die():
	emit_signal("wood_break")
	$barrel.queue_free()
	$CollisionShape.queue_free()
	queue_free()
