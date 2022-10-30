extends KinematicBody



var Name = "Resignation 1/4"
onready var radius = $Area
var active = true
var note1 = "...3rd contamination this month... unacceptable conditions..."
var note2 = "...budget to study interdimensional materials but not proper janitorial staff"
var note3 = "...how can we avoid touching flesh phage contaminants without proper PPE?"
var note4 = "...on top of that the elevator is constantly out of order... fuck this job"

var current_note = 1
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
			if current_note == 1:
				n.dialogue_text = note1
				n.tick_dialogue()
				current_note = 2
				Name = "Resignation 2/4"
			elif current_note == 2:
				n.dialogue_text = note2
				n.tick_dialogue()
				current_note = 3
				Name = "Resignation 3/4"
			elif current_note == 3:
				n.dialogue_text = note3
				n.tick_dialogue()
				current_note = 4
				Name = "Resignation 4/4"
			elif current_note == 4:
				n.dialogue_text = note4
				n.tick_dialogue()
				current_note = 1
				Name = "Resignation 1/4"
				
