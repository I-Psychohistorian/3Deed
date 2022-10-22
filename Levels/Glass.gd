extends CSGBox


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_Timer_timeout():
	queue_free()


func _on_ExplosionManager_boom():
	$BrokenGlass.emitting = true
	$BrokenGlass2.emitting = true
	$BrokenGlass3.emitting = true
	$BrokenGlass4.emitting = true
	$BrokenGlass5.emitting = true
	$Timer.start()
