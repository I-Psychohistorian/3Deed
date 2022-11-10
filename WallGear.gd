extends KinematicBody


var Name = "Turn gear wheel"
var jam_text = "It's jammed"
var active = true
var jammed = false
var clockwise = true

var turning = false
var turn_degree = -5

signal raise
signal lower
signal sister

onready var area = $Area

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func use():
	var bodies = area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group('Player'):
			if jammed == true:
				body.dialogue_text = jam_text
				body.tick_dialogue()
			if jammed == false:
				gear_functions()
				emit_signal("sister")

func gear_functions():
	if clockwise == true:
		counter_clockwise_raise()
		active = false
	elif clockwise == false:
		clockwise_lower()
		active = false

func counter_clockwise_raise():
	turn_degree = -6
	turning = true
	emit_signal("raise")
	#sounds?

func clockwise_lower():
	turn_degree = 6
	turning = true
	emit_signal("lower")


func _on_Turn_tick_timeout():
	if turning == true:
		self.rotate_z(deg2rad(turn_degree))


func _on_Turn_timer_timeout():
	pass


func _on_Gate_stopped():
	active = true
	turning = false
	if clockwise == true:
		clockwise = false
	elif clockwise == false:
		clockwise = true


func _on_KnifeKinematic_jam():
	jammed = true


func _on_KnifeKinematic_knife_pickup():
	jammed = false


func _on_WallGear_sister():
	gear_functions()


func _on_WallGear2_sister():
	gear_functions()
