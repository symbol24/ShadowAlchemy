extends RigidBody2D

const TEST_FX = preload("res://Scenes/FX/test_fx.tscn")

@onready var hit_area = %hit_area

func _ready():
	hit_area.body_entered.connect(hit_detect)

func hit_detect(_body):
	var hitfx = TEST_FX.instantiate()
	GameMode.world.add_child.call_deferred(hitfx)
	hitfx.global_position = global_position
