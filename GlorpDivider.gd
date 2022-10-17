extends Spatial





# Called when the node enters the scene tree for the first time.
func _ready():
	reparent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func reparent():
	var new_parent = get_parent().get_parent()
	#print(new_parent)
	#print(get_parent())
	#print(new_parent.get_parent())
	get_parent().remove_child(self)
	new_parent.get_parent().add_child(self)

func die():
	$Timer.start()

func clone():
	var spawn = preload("res://Entities/GlorpDivider2ndPhase.tscn")
	print('cloning glorper phase 1')
	var b = spawn.instance()
	self.add_child(b)
	b.clone()
	die()


func _on_Timer_timeout():
	queue_free()
