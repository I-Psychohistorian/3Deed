extends CanvasLayer


var stamina = 0
var health = 0
var status = false
var sprint = false
var ammo = 0 
var powerups = 0
var tooltip = 'testing'
var equipped = []

# Declare member variables here. Examples:
onready var health_display = $MarginContainer/Health
onready var stamina_display = $MarginContainer/Stamina
onready var ammo_display = $MarginContainer/Ammo
onready var sprint_display = $MarginContainer/Sprint
onready var powerups_display = $MarginContainer/Powerups

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	health_display.text = "Health " + String(health)
	stamina_display.text = "Stamina " + String(stamina)
	ammo_display.text = "Ammo " + String(ammo)
	powerups_display.text = "Bingo Beans " + String(powerups)
	if sprint == false:
		sprint_display.text = "Sprint Off"
	if sprint == true:
		sprint_display.text = "Sprint On"
	
