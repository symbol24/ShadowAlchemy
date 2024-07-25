extends SAEnemyAction

const SHIELDDATAS = [preload("res://Data/Enemies/Shields/shield_air.tres"), preload("res://Data/Enemies/Shields/shield_earth.tres"), preload("res://Data/Enemies/Shields/shield_fire.tres"), preload("res://Data/Enemies/Shields/shield_water.tres")]

@export var shield_element := GameMode.ELEMENT.AIR

@onready var sprite:Sprite2D = %sprite
@onready var hit_detection:Area2D = %hit_detection
@onready var hit_collider:CollisionShape2D = %hit_collider
@onready var animator = %animator

var active := true
var shield_data:EnemyShieldData
var hp := 1.0

func _ready():
	super._ready()
	shield_data = set_data(shield_element, SHIELDDATAS)
	hp = shield_data.hp
	sprite.set_modulate(shield_data.color_modulation)
	hit_detection.area_entered.connect(_hit_detection)
	if !SAOwner or !SAOwner.is_node_ready(): await SAOwner.ready
	SAOwner.hit_collider.disabled = true

func set_data(_element := GameMode.ELEMENT.AIR, _datas:Array = []) -> EnemyShieldData:
	for each in _datas:
		if each.element == _element:
			return each
	return _datas[0]

func _hit_detection(_area):
	if _area.has_method("get_damages"):
		print("shield_data.element ", shield_data.element)
		for damage in _area.get_damages():
			print("damage.elements ", damage.elements)
			print("GameMode.check_elements(shield_data.element, damage.elements) ", GameMode.check_elements(shield_data.element, damage.elements))
			if (GameMode.check_elements(shield_data.element, damage.elements)):
				hp -= damage.base_damage
		if hp <= 0:
			_deactivate()

func _deactivate():
	hit_collider.set_disabled.call_deferred(true)
	animator.play("deactivate")

func end_deactivation():
	SAOwner.hit_collider.set_disabled(false)
	sprite.hide()
