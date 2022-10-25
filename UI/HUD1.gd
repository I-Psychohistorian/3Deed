extends CanvasLayer


var stamina = 0
var health = 0
var status = false
var sprint = false
var ammo = 0 
var ammo2 = 0
var powerups = 0
var current_level = 0
var tooltip = 'testing'
var equipped = []
var examine_text = 'N'
var dialogue_text = 'G'
var status_text = 'S'

var interactable_seen = false

# Declare member variables here. Examples:
onready var weapon_display = $WeaponType
onready var health_display = $MarginContainer/Health
onready var stamina_display = $MarginContainer/Stamina
onready var ammo_display = $MarginContainer/Ammo
onready var sprint_display = $MarginContainer/Sprint
onready var powerups_display = $MarginContainer/Powerups
onready var interact_text = $Interact/InteractText
onready var examine_display = $TextOverlay/Text
onready var dialogue_display = $DialogueBox/DialogueLabel
onready var status_display = $DialogueBox/Status
# Called when the node enters the scene tree for the first time.
signal playerupdate
#menu and save ui
var menu_toggle = false

func _ready():
	$MainMenu.enabled = false
	$MainMenu.toggle()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	health_display.text = "Health " + String(health)
	stamina_display.text = "Stamina " + String(stamina)
	ammo_display.text = "Ammo " + String(ammo2) + "/" + String(ammo)
	powerups_display.text = "Bingo Beans " + String(powerups)
	weapon_display.text = String(equipped) + " equipped"
	examine_display.text = examine_text
	dialogue_display.text = dialogue_text
	status_display.text = status_text
	if sprint == false:
		sprint_display.text = "Sprint Off"
	if sprint == true:
		sprint_display.text = "Sprint On"

func menu_visible():
	if menu_toggle == true:
		menu_toggle = false
		$MainMenu.visible = true
		$MainMenu.toggle()
	elif menu_toggle == false:
		menu_toggle = true
		$MainMenu.visible = false
		$MainMenu.toggle()

func dialogue():
	dialogue_display.show()
	$DialogueTimer.start()

func status():
	status_display.show()
	$StatusTimer.start()

func see_e():
	interactable_seen = true
	interact_text.show()
	examine_display.show()
	
func unsee_e():
	interactable_seen = false
	interact_text.hide()
	examine_display.hide()

func die():
	$DeathReturn.disabled = false
	$DeathReturn.visible = true

func undie():
	$DeathReturn.disabled = true
	$DeathReturn.visible = false


func updateGM():
	emit_signal("playerupdate")

func allow_save():
	$MainMenu.can_save()

func _on_DialogueTimer_timeout():
	dialogue_display.hide()


func _on_StatusTimer_timeout():
	status_display.hide()


func _on_Button_pressed():
	get_tree().change_scene("res://Levels/TestWorld.tscn")


func _on_MainMenu_hud_to_player_GM():
	updateGM()
