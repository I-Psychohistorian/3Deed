extends CSGCombiner

var closed = false
var closing = false

onready var iris = $PortalTube/PortalIris
signal portal_closed
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#wprint(iris.radius)
	if closing == true:
		iris.radius -= 0.03
		if iris.radius <= 0:
			closing = false


func _on_PlayerDetector_body_exited(body):
	if closed == false:
		if body.is_in_group('Player'):
			iris.radius = 1.6
			$PortalWait.start()
			


func _on_PortalCloser_timeout():
	$Ambient.stream_paused = true
	closing = false
	closed = true
	emit_signal("portal_closed")


func _on_PortalWait_timeout():
	$PortalClose.play()
	$PortalCloser.start()
	closing = true
