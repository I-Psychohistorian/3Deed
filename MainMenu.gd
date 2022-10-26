extends Control


var enabled = true

onready var Start = $VBoxContainer/StartResume
onready var Save = $VBoxContainer/Save
onready var Load = $VBoxContainer/Load
onready var Controls = $VBoxContainer/Controls
onready var Settings = $VBoxContainer/Settings
onready var Quit = $VBoxContainer/Quit
var save_path = "user://save.tres"

signal hud_to_player_GM

# Called when the node enters the scene tree for the first time.
func _ready():
	var dir = Directory.new()
	if not dir.file_exists(save_path):
		$VBoxContainer/Load.disabled = true
		$VBoxContainer/Save.text = "Save Checkpoint Progress"
	else:
		$VBoxContainer/Load.disabled = false
		$VBoxContainer/Save.text = "Overwrite Saved Checkpoint"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func can_save():
	$VBoxContainer/Save.disabled = false

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
	#perhaps make scene distinct from all other start points?

func _on_Quit_pressed():
	get_tree().quit()


func _on_Save_pressed():
	#emit_signal("hud_to_player_GM") #this sets current state for save
	#save should only start level though
	var new_save = Save_Slot.new()
	new_save.take_save_data()
	#print(new_save)
	#print(new_save.health)
	#print(new_save.current_level)
	ResourceSaver.save(save_path, new_save)
	
func _on_Load_pressed():
	var dir = Directory.new()
	if not dir.file_exists(save_path):
		print('fail')
		return false
	var old_save = load(save_path)
	#print(old_save)
	#print(old_save.health)
	#print(old_save.current_level)
	old_save.set_save()
	get_tree().change_scene(old_save.current_level)
	pass # Replace with function body.
