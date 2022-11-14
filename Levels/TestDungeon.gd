extends Spatial


var current_level = "res://Levels/TestDungeon.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_McGuffin_body_entered(body):
	if body.is_in_group("Player"):
		body.update_stats_GM()
		get_tree().change_scene("res://Levels/TestWorld.tscn")
