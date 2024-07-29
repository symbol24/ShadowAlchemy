class_name SkeletonWarrion extends SAEnemy

@onready var projectile_point:Marker2D = %projectile_point

func _ready():
	super._ready()
	name = "SkeletonMage"

func shoot():
	var target_direction = global_position.direction_to(target.global_position).x
	if sprite.flip_h and target_direction > 0.0:
		_flip_items(target_direction, to_flip)
	elif !sprite.flip_h and target_direction < 0.0:
		_flip_items(target_direction, to_flip)
	SASignals.MageShoot.emit(self)
