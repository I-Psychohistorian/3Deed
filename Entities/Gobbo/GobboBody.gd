extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var sight_area = $Sight
onready var head_joint = $GobboHead

# Called when the node enters the scene tree for the first time.
func _ready():
	$GobboHead/FaceAnim.play("Blink")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	test_look()
	pass

func test_look():
	var bodies = sight_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Player"):
			var look_point = body.global_transform.origin + Vector3(0, 1, 0)
			head_joint.look_at(look_point, Vector3.UP)
			head_joint.rotation.z = clamp(self.rotation.z, deg2rad(-50), deg2rad(80))
			#clamping broken, will need to fix
