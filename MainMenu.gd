extends Control


var enabled = true

onready var Start = $VBoxContainer/StartResume
onready var Save = $VBoxContainer/Save
onready var Load = $VBoxContainer/Load
onready var Controls = $VBoxContainer/Controls
onready var Settings = $VBoxContainer/Settings
onready var Quit = $VBoxContainer/Quit


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func toggle():
	pass
	#if enabled == true:
		#for x in button_list:
			#x.disabled = true
	#elif enabled == false:
		#for x in button_list:
			#x.disabled = false
			
func _on_StartResume_pressed():
	get_tree().change_scene("res://Levels/TestWorld.tscn")


func _on_Quit_pressed():
	get_tree().quit()


func _on_Save_pressed():
	var state_data = GameManager.instance()
	var level_data = 0

func _on_Load_pressed():
	pass # Replace with function body.
