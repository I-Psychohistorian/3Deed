extends CSGBox



var rng = RandomNumberGenerator.new()

onready var room1 = preload("res://Levels/Rooms/TestRoom1.tscn")
onready var room2 = preload("res://Levels/Rooms/Testroom2.tscn")
onready var room3 = preload("res://Levels/Rooms/TestRoom3.tscn")


var current_room = "n"
# Called when the node enters the scene tree for the first time.
func _ready():
	pick_room()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func pick_room():
	rng.randomize()
	var choice = rng.randi_range(0,3)
	print(choice)
	if choice == 0:
		current_room = room1
	elif choice == 1:
		current_room = room2
	elif choice >= 2:
		current_room = room3
	var new_room = current_room.instance()
	self.add_child(new_room)
