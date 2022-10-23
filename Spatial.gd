extends Spatial


var rng = RandomNumberGenerator.new()
var x_spin = 0
var y_spin = 0
var z_spin = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	spin()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_x(deg2rad(x_spin))
	rotate_y(deg2rad(y_spin))
	rotate_z(deg2rad(z_spin))
	
func spin():
	rng.randomize()
	x_spin = rng.randi_range(-1,1)
	rng.randomize()
	y_spin = rng.randi_range(-1,1)
	rng.randomize()
	z_spin = rng.randi_range(-1,1)
	print(x_spin, y_spin, z_spin)
	
	
