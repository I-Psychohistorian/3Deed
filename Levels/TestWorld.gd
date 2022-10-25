extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_level = "res://Levels/TestWorld.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Teleporter_body_entered(body):
	if body.is_in_group("Player"):
		body.update_stats_GM
		get_tree().change_scene("res://Levels/GlorpChamber.tscn")


func _on_SecondTeleporter_body_entered(body):
	if body.is_in_group("Player"):
		body.update_stats_GM
		get_tree().change_scene("res://Levels/TestDungeon.tscn")
