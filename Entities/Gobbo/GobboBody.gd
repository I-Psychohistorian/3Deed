extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var sight_area = $Sight
onready var head_joint = $GobboHead

var anim_states = ["Idle", "Animate"]
var current_state = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$GobboHead/FaceAnim.play("Blink")
	current_state = anim_states[0]
	print(current_state)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	test_look()
	pass

func test_look():
	var bodies = sight_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Player"):
			var look_point = body.global_transform.origin + Vector3(0, 0.7, 0)
			head_joint.look_at(look_point, Vector3.UP)
			if head_joint.rotation.y > deg2rad(70):
				head_joint.rotation.y = deg2rad(70)
			if head_joint.rotation.y < deg2rad(-70):
				head_joint.rotation.y = deg2rad(-70)
			if head_joint.rotation.x > deg2rad(45):
				head_joint.rotation.x = deg2rad(45)
			if head_joint.rotation.x < deg2rad(-45):
				head_joint.rotation.x = deg2rad(-45)

func _on_DebugReport_timeout():
	$BodyAnim.play("Dopey")
