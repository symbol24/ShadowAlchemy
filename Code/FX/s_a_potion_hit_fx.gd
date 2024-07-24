class_name SAPotionHitFX extends Area2D

@export var data:HitFxData

@onready var animator:AnimationPlayer = %animator

#func _ready():
	#print("hit_fx in ready: ", global_position)

func destroy():
	queue_free.call_deferred()
