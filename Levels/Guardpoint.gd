extends Spatial


# Declare member variables here. Examples:
# var a = 2
onready var golem = $WoodGolem


# Called when the node enters the scene tree for the first time.
func _ready():
	golem.guard_point = self.global_transform.origin
	golem.guarding = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area_body_entered(body):
	if body.is_in_group('Golem'):
		body.guardpoint_found = true
		body.deactivate()
