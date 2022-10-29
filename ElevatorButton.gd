extends KinematicBody

var Name = "Go down"
var active = true
var in_use = false

signal use_elevator

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func use():
	$Delay.start()

func _on_Delay_timeout():
	if in_use == false:
		in_use = true
		emit_signal("use_elevator")
		#sound
