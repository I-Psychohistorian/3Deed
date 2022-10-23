extends Spatial


var closing = false
var closed = false
var leaving = false

var movement = Vector3(0, 1, 0)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if closing == true:
		$ZenPortal/Iris.radius += 0.05
		if $ZenPortal/Iris.radius >= 1.6:
			closing = false
			closed = true
			$CloseTimer.start()
			$LeaveTimer.start()
	if closed == true:
		$ZenPortal.translate(get_transform().basis.xform(movement))


func _on_Area_body_exited(body):
	if body.is_in_group('Player'):
		closing = true
		$ZenPortal/PortalClose.play()


func _on_CloseTimer_timeout():
	$CSGCylinder.queue_free()
	


func _on_LeaveTimer_timeout():
	queue_free()
