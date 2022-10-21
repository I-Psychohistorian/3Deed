extends KinematicBody


var Name = "Inject Serum"
var pickup = "Vaccinated"
var wrong_dosage = "Serum_overdose"
onready var radius = $Area
var active = true
var dialogue = "You inject the serum into yourself. A strange warmth spreads into your blood."
var overdose = "You inject more serum into yourself. You begin to feel incredibly feverish."
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
			if n.vaccinated == false:
				n.status_effects.append(pickup)
				n.vaccinated = true
				print(String(n.status_effects))
				n.dialogue_text = dialogue
				$AudioStreamPlayer3D.play()
				n.immunity = 50
			elif n.serum_overdose == true:
				n.health -= 1000
			elif n.vaccinated == true:
				n.status_effects.append(wrong_dosage)
				n.dialogue_text = overdose
				n.OD.start()
				n.serum_overdose = true
				n.immunity = 60
			n.tick_dialogue()
			$AudioStreamPlayer3D.play()
			$Needle/Cap.visible = false
			active = false
			$PlungeEmpty.visible = true
			$Contents.visible = false
			$PlungeFull.visible = false
			
