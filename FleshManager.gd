extends Spatial


onready var fleshseeker = preload("res://Entities/FleshThing/EbolaWorm.tscn")
onready var area = $FleshArea

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func spawn_seeker():
	for body in area.get_overlapping_bodies():
		if body.is_in_group("FleshShooter"):
			var parent_flesh_position = body.spawn_coords
			var f = fleshseeker.instance()
			add_child(f)
			f.global_transform.origin = parent_flesh_position
			print('spawned')


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
