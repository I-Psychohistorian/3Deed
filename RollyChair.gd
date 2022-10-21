extends KinematicBody



var Name = "Spin Rolly Chair"
var pickup = "RollerChair"
onready var radius = $Area
var active = true
var fun = "Wheee!"
var spinning = false
var momentum = 30
var health = 40
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if spinning == true:
		self.rotate_y(deg2rad(1+momentum))
		if momentum > 0:
			momentum -= 1

func use():
	var bodies = radius.get_overlapping_bodies()
	for n in bodies:
		if n.is_in_group("Player"):
				spinning = true
				$Spin_timer.start()
				n.dialogue_text = fun
				n.tick_dialogue()


func _on_Spin_timer_timeout():
	spinning = false
	momentum = 30
