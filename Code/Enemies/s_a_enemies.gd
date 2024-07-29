class_name SAEnemy extends SACharacterBody2D

@export var shield_element := GameMode.ELEMENT.AIR

var attacking := false
var target:SAMainCharacter
var room_in:SARooms

func _ready():
	super._ready()
	room_in = get_parent() as SARooms
	SASignals.EnemyAttack.connect(_trigger_attack)

func _process(_delta):
	if !target and GameMode.character: target = GameMode.character

func _physics_process(_delta):
	if GameMode.is_playing():
		grounded = is_on_floor()
		if !grounded: _apply_gravity(_delta)
		
		move_and_slide()
		
		var look_dir := 1.0
		if target: look_dir = global_position.direction_to(target.global_position).x
		
		_flip_items(look_dir, to_flip)
		_direction_check(direction)
		_state_check_for_animation(current_state)

func character_dead():
	queue_free.call_deferred()

func _trigger_attack(_enemy:SAEnemy):
	if _enemy == self:
		_update_state(self, STATE.ATTACKING)
		_update_animation(self, "attack")
		
func get_distance_to_target(_target:SAMainCharacter = null) -> float:
	if _target:
		#print(global_position.distance_squared_to(_target.global_position))
		return global_position.distance_squared_to(_target.global_position)
	
	return 10000000

func _hit_detection(_area):
	if _area.has_method("get_damages"):
		data.receive_damage(_area.get_damages())
