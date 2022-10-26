class_name Save_Slot
extends Resource

const save_path = "user://save.tres"

export var powerups = 1
export var unlocked_weapons = []
export var health = 100
export var stamina = 100
export var disease = false
export var immunity = 20
export var vaccinated = false
export var serum_overdose = false
export var ammo = 0
export var ammo_in_gun = 0

export var keycard = false
export var dimensional_keys = 0
export var hungry = true
export var Murders = 0

export var blungus_friend = true
export var fairy_friend = true
export var fairy_quest_failed = false
export var fairy_quest_succeeded = false
export var goblin_spared = true

export var current_level = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func take_save_data():
	powerups = GameManager.powerups
	unlocked_weapons = GameManager.unlocked_weapons
	health = GameManager.health
	stamina = GameManager.stamina
	disease = GameManager.disease
	vaccinated = GameManager.vaccinated
	immunity = GameManager.immunity
	serum_overdose = GameManager.serum_overdose
	ammo = GameManager.ammo
	ammo_in_gun = GameManager.ammo_in_gun
	Murders = GameManager.Murders
	keycard = GameManager.keycard
	dimensional_keys = GameManager.dimensional_keys
	current_level = GameManager.current_level
	
	blungus_friend = GameManager.blungus_friend
	fairy_friend = GameManager.fairy_friend
	fairy_quest_failed = GameManager.fairy_friend
	fairy_quest_succeeded = GameManager.fairy_quest_succeeded
	goblin_spared = GameManager.goblin_spared

func set_save():
	GameManager.powerups = powerups
	GameManager.unlocked_weapons = unlocked_weapons
	GameManager.health = health
	GameManager.stamina = stamina
	GameManager.disease = disease
	GameManager.vaccinated = vaccinated
	GameManager.immunity = immunity
	GameManager.serum_overdose = serum_overdose
	GameManager.ammo = ammo
	GameManager.ammo_in_gun = ammo_in_gun
	GameManager.Murders = Murders
	GameManager.keycard = keycard
	GameManager.dimensional_keys = dimensional_keys
	GameManager.current_level = current_level
	
	GameManager.blungus_friend = blungus_friend
	GameManager.fairy_friend = fairy_friend
	GameManager.fairy_quest_failed = fairy_quest_failed
	GameManager.fairy_quest_succeeded = fairy_quest_succeeded
	GameManager.goblin_spared = goblin_spared

func save_game() -> void:
	take_save_data()
	ResourceSaver.save(save_path, self)
	
func load_game() -> void:
	set_save()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
