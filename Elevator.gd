extends StaticBody


var up = true
var position = Vector3()
var y_distance = Vector3()
var y_inc_p = 0.039
var y_inc_n = -0.039
var moving = false
signal toggle_call_basement
signal toggle_call_upper

onready var door1 = $DoorRight
onready var door2 = $DoorLeft
# Called when the node enters the scene tree for the first time.
func _ready():
	$Sound.stream_paused = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	elevate()


func _on_ElevatorButton_use_elevator():
	close_doors()
	$MoveTime.start()
	moving = true
	$Sound.stream_paused = false

func elevate():
	if moving == true:
		position = self.global_transform.origin
		var y = 0
		if up == true:
			y_distance = position
			y = y_inc_n
		elif up == false:
			y_distance = position
			y = y_inc_p
		self.translate_object_local(Vector3(0, y, 0))

func close_doors():
	door1.translate_object_local(Vector3(0.9, 0, 0))
	door2.translate_object_local(Vector3(-0.9, 0, 0))
	$Close.play()
	
func open_doors():
	$Sound.stream_paused = true
	door2.translate_object_local(Vector3(0.9, 0, 0))
	door1.translate_object_local(Vector3(-0.9, 0, 0))
	$Open.play()
	if up == true:
		emit_signal("toggle_call_basement")
	elif up == false:
		emit_signal("toggle_call_upper")
func _on_MoveTime_timeout():
	moving = false
	if up == true:
		up = false
		$ElevatorButton.Name = "Go up"
	elif up == false:
		up = true
		$ElevatorButton.Name = "Go down"
	$ElevatorButton.in_use = false
	$Close_Open.start()


func _on_Close_Open_timeout():
	open_doors()


func _on_ElevatorCall_call():
	close_doors()
	$MoveTime.start()
	moving = true
	$Sound.stream_paused = false


func _on_BottomCall_call_basement():
	close_doors()
	$MoveTime.start()
	moving = true
	$Sound.stream_paused = false

