extends SAAction

@export var potions:Array[PotionData] = []

@onready var timer:Timer = %timer
@onready var aim_line:Line2D = %aim_line

var can_throw := true
var aim_direction := Vector2.ZERO
var max_radius := 30.0
var toggle_pressed := false
var toggle_delay := 0.2
var toggle_timer := 0.0

var selection := 0:
	set(value):
		selection = value
		SASignals.PotionSelectionChanged.emit(selection)

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
		if aim_direction != Vector2.ZERO and SAInput.action_7:
			throw(aim_direction.normalized(), potions[selection])
		
		if SAInput.action_5: selection = tab_selection(selection, true)
		elif SAInput.action_8: selection = tab_selection(selection, false)
		
		if toggle_pressed:
			toggle_timer += _delta
			if toggle_timer >= toggle_delay:
				toggle_pressed = false
				toggle_timer = 0.0

func aim() -> Vector2:
	return Vector2(SAInput.aim_left_right, SAInput.aim_up_down)

func throw(_aim_direction:=Vector2.ZERO, _potion:PotionData = null):
	if can_throw and _potion:
		can_throw = false
		var loaded = load(_potion.potion_path)
		var new_potion = loaded.instantiate()
		GameMode.world.add_child(new_potion)
		new_potion.global_position = global_position
		new_potion.apply_central_impulse(_aim_direction.normalized() * get_final_throw_strength())
		timer.wait_time = new_potion.data.throw_delay
		timer.start()

func _timer_timeout():
	can_throw = true

func get_point(_aim_direction := Vector2.ZERO, _max_length := 30.0):
	return Vector2(_max_length * _aim_direction.x, _max_length * _aim_direction.y)

func get_final_throw_strength() -> float:
	var strength:float = SAOwner.data.throw_strength
	strength = strength + ((SAOwner.data.speed/3) * (SAOwner.velocity.x / 100))
	return strength

func tab_selection(_current := 0, _left := false) -> int:
	toggle_pressed = true
	var new  = _current
	if _left: 
		new -= 1
		if new < 0: new = potions.size()-1
	else:
		new += 1
		if new >= potions.size(): new = 0
	return new
