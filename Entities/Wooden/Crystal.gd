extends Spatial


var spinning = false
var fire = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if spinning == true:
		self.rotate_y(0.1)
	elif spinning == false:
		self.rotate_y(0.002)
