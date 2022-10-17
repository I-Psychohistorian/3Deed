extends Spatial


onready var spawn = preload("res://Entities/BingoBean1.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func clone():
	print('2ndphase')
	var b = spawn.instance()
	self.add_child(b)
	b.reparent2()
	queue_free()
