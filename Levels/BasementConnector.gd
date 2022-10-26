extends CSGBox


onready var basement1 = preload("res://Levels/Rooms/Basement1.tscn")
onready var basement2 = preload("res://Levels/Rooms/Basement2.tscn")
var room = basement1
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	var choice = rng.randi_range(0,1)
	if choice == 0:
		room = basement1
	elif choice == 1:
		room = basement2
	print(room)
	var basement_room = room.instance()
	self.add_child(basement_room)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
