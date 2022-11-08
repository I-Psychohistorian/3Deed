extends Spatial


var current_level = "res://Levels/TutorialRooms.tscn"

var instructions = ["WASD to move", "E to interact with objects", "Q to swap equipment", "LMB to attack, RMB for reloading/alt fire"]
var textnum = 0

onready var player = $Player
# Called when the node enters the scene tree for the first time.
func _ready():
	tutorial_text()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func tutorial_text():
	player.dialogue_text = instructions[textnum]
	player.tick_dialogue()
	textnum +=1
