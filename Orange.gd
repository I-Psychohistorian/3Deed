extends KinematicBody


var Name = "Orange"
var active = true
var eat_text = "You eat the orange. Citrusy goodness."
onready var radius = $Area
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func use():
	var bodies = radius.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Player"):
			body.stamina += 5
			body.health += 1
			body.crunch.play()
			body.dialogue_text = eat_text
			body.tick_dialogue()
			queue_free()
