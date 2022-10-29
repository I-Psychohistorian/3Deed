extends KinematicBody


var Name = "Flip lightswitch"
var active = true
signal toggle_light

# Called when the node enters the scene tree for the first time.
func _ready():
	connect_to_children()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func use():
	$Switch.play()
	emit_signal("toggle_light")
	
func connect_to_children():
	var lamps = get_children()
	for lamp in lamps:
		connect('toggle_light', lamp, "toggle")
