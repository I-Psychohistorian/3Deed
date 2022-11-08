extends KinematicBody


var raising = false
var lowering = false

var speed = 0.3
signal stopped

var up = Vector3(0, 1, 0)
var down = Vector3(0, -1, 0)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if raising == true:
		var direction = up #self.global_transform.origin + up
		move_and_slide(direction * (speed), Vector3.UP)
	if lowering == true:
		var direction = down #self.global_transform.origin + down
		move_and_slide(direction * (speed), Vector3.UP)
	# add audio

func _on_Closed_stop_body_entered(body):
	if body.is_in_group('Gate'):
		lowering = false
		emit_signal("stopped")


func _on_Open_stop_body_entered(body):
	if body.is_in_group('Gate'):
		raising = false
		emit_signal("stopped")


func _on_WallGear_lower():
	lowering = true
	#sound


func _on_WallGear_raise():
	raising = true
	#sound


func _on_Timer_timeout():
	if raising == true:
		$Gatecreak.play()
	if lowering == true:
		$Gatecreak.play()
