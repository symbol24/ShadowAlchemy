class_name SAPotionParticle extends RigidBody2D

@export var data:ParticleData

@onready var damage_area:Area2D = %damage_area
@onready var timer:Timer = %timer

var damages:Array[Damage] = []

func _ready():
	if timer and data.life_time > 0.0:
		timer.wait_time = data.life_time
		timer.timeout.connect(destroy)
		timer.start()

func apply_throw(_direction:Vector2 = Vector2.UP):
	apply_central_impulse(_direction * data.speed * randf_range(0.95, 1.05))

func destroy():
	queue_free.call_deferred()

