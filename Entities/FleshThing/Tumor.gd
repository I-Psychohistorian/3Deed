extends KinematicBody


var popped = false
var spawn_point = Vector3()


# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_point = $WormSpawn.global_transform.origin


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func pop():
	popped = true
	$CSGSphere/HeadSplatter2.emitting = true
	$CSGSphere/TumorHole.visible = true
