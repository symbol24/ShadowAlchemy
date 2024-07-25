extends SAEnemyAction

var idle_timer := 0.0
var chase_timer := 0.0
var direction := 0.0

func _ready():
	super._ready()

func _physics_process(_delta):
	if GameMode.is_playing() and SAOwner and SAOwner.target:
		if SAOwner.get_distance_to_target(SAOwner.target) <= SAOwner.data.attack_distance:
			direction = 0.0
		elif SAOwner.get_distance_to_target(SAOwner.target) < SAOwner.data.max_distance_to_target:
			direction = global_position.direction_to(SAOwner.target.global_position).x
		else:
			direction = 0.0
		
		var new_x = _walk_and_idle(_delta, direction)
		if SAOwner.can_move:
			SAOwner.velocity.x = new_x
			SAOwner.direction = direction

func _walk_and_idle(_delta:= 0.0, _direction := 0.0) -> float:
	var new_x:float = SAOwner.velocity.x
	var air_or_ground_multiplier = 1.0
	#if !grounded: air_or_ground_multiplier = AIR_MULTIPLIER
	
	if _direction > 0.1 or _direction < -0.1:
		new_x = move_toward(new_x, SAOwner.data.speed * _direction, _delta * SAOwner.data.acceleration * air_or_ground_multiplier)
	else:
		new_x = move_toward(new_x, 0, _delta * SAOwner.data.friction * air_or_ground_multiplier)

	new_x = clampf(new_x, -SAOwner.data.speed, SAOwner.data.speed)

	return new_x
