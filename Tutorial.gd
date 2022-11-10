extends Spatial


var current_level = "res://Levels/TutorialRooms.tscn"

var instructions = ["WASD to move", "Spacebar to jump", "Shift to toggle sprint", "Sprintmode drains stamina but increase jumpheight and movespeed", "Q to toggle equipped item", "LMB to attack, RMB to Reload/Alt fire (when available)", "Good luck!"]
var textnum = 0
var jump_t = true
var sprint_t = true
var equip_t = true

var fake_bozo_1 = "Bozo: Hmm, you aren't allowed to be back here"
var d1 = true
var waited = false
var wait_text = "Bozo: You're a curious creature. Perhaps you will do..."
var fake_bozo_2 = "Bozo: Why don't we have some fun? Ehehehe."
var d2 = true

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


func _on_Tutorial_area_1_body_entered(body):
	if jump_t == true:
		if body.is_in_group('Player'):
			player.dialogue_text = instructions[textnum]
			player.tick_dialogue()
			textnum +=1
			jump_t = false


func _on_Tutorial_area_2_body_entered(body):
	if sprint_t == true:
		if body.is_in_group('Player'):
			player.dialogue_text = instructions[textnum]
			player.tick_dialogue()
			textnum +=1
			sprint_t = false
			$Tutorial_area_2/TutorialTimer1.start()


func _on_TutorialTimer1_timeout():
	player.dialogue_text = instructions[textnum]
	player.tick_dialogue()
	textnum +=1


func _on_Tutorial_area_3_body_entered(body):
	if equip_t == true:
		if body.is_in_group('Player'):
			player.dialogue_text = instructions[textnum]
			player.tick_dialogue()
			textnum +=1
			equip_t = false
			$Tutorial_area_3/TutorialTimer2.start()


func _on_TutorialTimer2_timeout():
	player.dialogue_text = instructions[textnum]
	player.tick_dialogue()
	textnum +=1


func _on_Dialogue1_body_entered(body):
	if body.is_in_group("Player"):
		if d1 == true:
			d1 = false
			player.dialogue_text = fake_bozo_1
			player.tick_dialogue()
			$Dialogue1/Followup.start()

func _on_Followup_timeout():
	if waited == false:
		waited = true
		player.dialogue_text = wait_text
		player.tick_dialogue()


func _on_DialogueTrap_body_entered(body):
	if body.is_in_group("Player"):
		if d2 == true:
			d2 = false
			waited = true
			player.dialogue_text = fake_bozo_2
			player.tick_dialogue()
			$TrapTime.start()



