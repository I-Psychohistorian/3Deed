extends CSGSphere


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.rotate_y(deg2rad(0.1))


func _on_DeathZone_body_exited(body):
	if body.is_in_group('Player'):
		body.take_damage(1000)
