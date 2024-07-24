class_name TestPotion extends RigidBody2D

@export var data:PotionData

@onready var break_collider:Area2D = %break_collider
@onready var break_shape:CollisionShape2D = %break_shape

var loaded

func _ready():
	loaded = load(data.hit_fx_path)
	break_collider.body_entered.connect(break_potion)
	await get_tree().create_timer(0.2).timeout
	break_shape.disabled = false
	
	
func break_potion(_body):
	for each in _body.get_groups():
		if each in ["ground", "enemy"]: 
			var hit_fx = loaded.instantiate()
			hit_fx.global_position = global_position
			GameMode.world.add_child.call_deferred(hit_fx)
			#hit_fx.play()
			queue_free.call_deferred()
