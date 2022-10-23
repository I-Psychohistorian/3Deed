extends Area


onready var hub = "res://Levels/TestWorld.tscn"
onready var facility = "res://Levels/ClosetStart.tscn"

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TeleportArea_body_entered(body):
	if body.is_in_group("Player"):
		var choice = rng.randi_range(1,2)
		if choice == 1:
			get_tree().change_scene(hub)
		elif choice == 2:
			get_tree().change_scene(facility)
