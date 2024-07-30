class_name SAPotionHitFX extends Area2D

@export var data:HitFxData

@onready var animator:AnimationPlayer = %animator

func _ready():
	if data.audio_file:
		Audio.play(data.audio_file)
	#print("hit_fx in ready: ", global_position)

func get_damages() -> Array[Damage]:
	return data.damages

func destroy():
	queue_free.call_deferred()
