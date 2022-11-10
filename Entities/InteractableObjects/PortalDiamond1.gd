extends CSGPolygon


var target_location = ["Hub", "Lab", "SlimeGarden", "BossFight", "Random"]
var current_target = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	current_target = target_location[4]
	check_target()

func check_target():
	print(current_target)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
