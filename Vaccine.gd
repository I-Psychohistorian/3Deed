extends KinematicBody


var Name = "Inject Serum"
var pickup = "Vaccinated"
onready var radius = $Area
var active = true
var dialogue = "You inject the serum into yourself. A strange warmth spreads into your blood."
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
			n.status_effects.append(pickup)
			n.vaccinated = true
			print(String(n.status_effects))
			n.dialogue_text = dialogue
			n.tick_dialogue()
			$AudioStreamPlayer3D.play()
			n.immunity = 50
			active = false
			$PlungeEmpty.visible = true
			$Contents.visible = false
			$PlungeFull.visible = false
