class_name SAMainCharacter extends SACharacterBody2D

const HEAL_FX = preload("res://Scenes/FX/heal_fx.tscn")

@export var god_mode := false

@onready var camera_remote:RemoteTransform2D = %camera_remote

func _ready():
	super._ready()
	#SASignals.TeleportCharacter.connect()
	SASignals.AddStone.connect(_add_stone)
	if !camera_remote.is_node_ready(): await camera_remote.ready
	name = "MainCharacter"
	SASignals.HealCharacter.connect(_heal)
	await get_tree().create_timer(0.1).timeout
	SASignals.CharacterReady.emit(self)
	SASignals.TeleportCharacter.connect(_teleport)

func _teleport(_pos := Vector2.ZERO):
	if _pos != Vector2.ZERO:
		global_position = _pos

func _add_stone():
	data.has_the_stone = true

func character_dead():
	SASignals.PlayerDead.emit()

func _hit_detection(_area):
	if _area.has_method("get_damages") and !god_mode:
		data.receive_damage(_area.get_damages())

func _heal(_character:SACharacterBody2D, _value := 0.0):
	if _character == self and _value > 0:
		var heal = HEAL_FX.instantiate()
		heal.position = Vector2.ZERO
		add_child(heal)
		data.update_hp(data.max_hp * _value)
