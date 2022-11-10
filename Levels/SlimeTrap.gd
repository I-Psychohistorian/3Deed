extends CSGBox


var sprung = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func spring_trap():
	if sprung == false:
		var chutes = get_children()
		for chute in chutes:
			chute.release()
		sprung = true


func _on_DialogueTrap_body_entered(body):
	pass
	#if sprung == false:
		#if body.is_in_group('Player'):
			#$TrapTime.start()
			#sprung = true


func _on_TrapTime_timeout():
	spring_trap()
