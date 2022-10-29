extends StaticBody


var up = true
var position = Vector3()
var y_distance = Vector3()
var y_inc_p = 0.04
var y_inc_n = -0.04
var moving = false


onready var door1 = $DoorRight
onready var door2 = $DoorLeft
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	elevate()


func _on_ElevatorButton_use_elevator():
	close_doors()
	$MoveTime.start()
	moving = true

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
	#close sound
	
func open_doors():
	door2.translate_object_local(Vector3(0.9, 0, 0))
	door1.translate_object_local(Vector3(-0.9, 0, 0))
	#open sound
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
