extends SAAction

@export var temp_potion:PackedScene

@onready var timer:Timer = %timer
@onready var aim_line:Line2D = %aim_line

var can_throw := true
var aim_direction := Vector2.ZERO
var max_radius := 30.0

func _ready():
	super._ready()
	if SAOwner: timer.wait_time = SAOwner.data.throw_delay
	timer.timeout.connect(_timer_timeout)

func _process(_delta):
	if SAOwner and GameMode.is_playing():
		aim_direction = aim()
		if aim_direction != Vector2.ZERO: 
			aim_line.show()
			aim_line.set_point_position(1, get_point(aim_direction, max_radius))
		else:
			aim_line.hide()
		if SAInput.action_7:
			throw(aim_direction.normalized())

func aim() -> Vector2:
	return Vector2(SAInput.aim_left_right, SAInput.aim_up_down)

func throw(_aim_direction:=Vector2.ZERO):
	if can_throw:
		can_throw = false
		var new_potion = get_potion()
		GameMode.world.add_child(new_potion)
		new_potion.global_position = global_position
		new_potion.apply_central_impulse(_aim_direction.normalized() * get_final_throw_strength())
		timer.start()

func get_potion():
	return temp_potion.instantiate()

func _timer_timeout():
	can_throw = true

func get_point(_aim_direction := Vector2.ZERO, _max_length := 30.0):
	return Vector2(_max_length * _aim_direction.x, _max_length * _aim_direction.y)

func get_final_throw_strength() -> float:
	var strength:float = SAOwner.data.throw_strength
	strength = strength + ((SAOwner.data.speed/10) * (SAOwner.velocity.x / 100))
	return strength
