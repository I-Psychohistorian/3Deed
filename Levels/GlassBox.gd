extends CSGBox


var closed = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_x(0.001)

func die():
	queue_free()


func _on_Switchc_case_off():
	self.use_collision = false
	self.visible = false


func _on_Switchc_case_on():
	self.use_collision = true
	self.visible = true
