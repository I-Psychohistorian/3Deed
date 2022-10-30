extends KinematicBody


var Name = "Victory Burger"
var active = true
var text = "You win!!"
onready var radius = $Area
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_y(deg2rad(0.5))

func use():
	var bodies = radius.get_overlapping_bodies()
	for n in bodies:
		if n.is_in_group("Player"):
			n.dialogue_text = text
			n.tick_dialogue()
			n.take_damage(-10)
