extends KinematicBody


var Name = "Medical Supplies 20/20"
var pickup = "First Aid"
onready var radius = $Area
var active = true
var used = false
var supplies = 20
var cant_heal = "You aren't injured, there's no reason to patch yourself up."
var can_heal = "You patch yourself up as best you can."
var can_heal_diseased = "You patch yourself up, but can do nothing for the chill creeping through your veins."
var used_up = "You've already expended these supplies."
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func use():
	var bodies = radius.get_overlapping_bodies()
	for n in bodies:
		if n.is_in_group("Player"):
			if used == true:
				n.dialogue_text = used_up
				n.tick_dialogue()
			elif n.health >= 100:
				n.dialogue_text = cant_heal
				n.tick_dialogue()
			elif n.health < 100:
				if n.disease == false:
					n.dialogue_text = can_heal
					n.tick_dialogue()
				elif n.disease == true:
					n.dialogue_text = can_heal_diseased
					n.tick_dialogue()
				if n.health >= 100 - supplies:
					n.health += supplies
					var remainder = n.health - 100
					n.health -= remainder
					supplies = remainder
				elif n.health < 100 - supplies:
					n.health += supplies
					supplies = 0
				if supplies == 0:
					used = true
			Name = "Medical Supplies " + String(supplies) + "/20"
