class_name SAThrowablePotion extends RigidBody2D

@onready var hit_detection:Area2D = %hit_detection

func _ready():
	hit_detection.body_entered.connect(_collision_detection)

func _collision_detection(_area):
	for each in _area.get_groups():
		if each in ["ground", "enemy"]: 
			break_potion()
			return
	
func break_potion():
	#do_something
	queue_free.call_deferred()
