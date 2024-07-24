class_name TestPotion extends RigidBody2D

@export var data:PotionData

@onready var break_collider:Area2D = %break_collider

func _ready():
	break_collider.body_entered.connect(break_potion)
	
func break_potion(_body):
	var loaded = load(data.hit_fx_path)
	var hit_fx = loaded.instantiate()
	hit_fx.global_position = global_position
	GameMode.world.add_child.call_deferred(hit_fx)
	hit_fx.play()
