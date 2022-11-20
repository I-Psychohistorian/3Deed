extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var sight_area = $Sight
onready var head_joint = $GobboHead

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	test_look()
	pass

func test_look():
	var bodies = sight_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Player"):
			head_joint.look_at(body.global_transform.origin, Vector3.UP)
			#head_joint.rotation.x = clamp(self.rotation.x, deg2rad(50), deg2rad(-30))
			#clamping broken, will need to fix
