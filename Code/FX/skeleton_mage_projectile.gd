extends Area2D

@export var damages:Array[Damage] = []
@export var speed := 300.0

var direction := 1.0

func _process(_delta):
	if GameMode.is_playing():
		move_local_x(_delta * speed * direction)

func get_damages() -> Array[Damage]:
	hide()
	_destroy()
	return damages

func set_damage_owner(_owner:SACharacterData):
	for _damage in damages:
		_damage.damage_owner = _owner

func _destroy():
	await get_tree().create_timer(0.01).timeout
	queue_free.call_deferred()

func flip():
	for child in get_children():
		if child.is_in_group("to_flip"):
			child.position.x = -child.position.x
			if child is Sprite2D:
				child.flip_h = !child.flip_h
