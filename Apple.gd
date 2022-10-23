extends KinematicBody


var Name = "Ethereal Apple"
var active = true
var eat_text = "You eat the strange apple. It's delicious."
var sated_text = "You aren't hungry enough to eat anything."
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
			if body.hungry == true:
				body.stamina += 5
				body.health += 5
				body.crunch.play()
				body.hungry = false
				body.dialogue_text = eat_text
				body.tick_dialogue()
				queue_free()
			elif body.hungry == false:
				body.dialogue_text = sated_text
				body.tick_dialogue()
