extends SAEnemyAction

@onready var edge_detector:RayCast2D = %edge_detector

var idle_timer := 0.0
var chase_timer := 0.0
var direction := 0.0

func _ready():
	super._ready()

func _physics_process(_delta):
	if GameMode.is_playing() and SAOwner and SAOwner.target and GameMode.world and GameMode.world.get_active_room() == SAOwner.room_in and !SAOwner.is_dead():
		flip()
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
	else:
		SAOwner.velocity.x = 0
		SAOwner.direction = 0

func _walk_and_idle(_delta:= 0.0, _direction := 0.0) -> float:
	var new_x:float = SAOwner.velocity.x
	var air_or_ground_multiplier = 1.0
	#if !grounded: air_or_ground_multiplier = AIR_MULTIPLIER
	
	if _direction > 0.1 or _direction < -0.1:
		new_x = move_toward(new_x, SAOwner.data.speed * _direction, _delta * SAOwner.data.acceleration * air_or_ground_multiplier)
	else:
		new_x = move_toward(new_x, 0, _delta * SAOwner.data.friction * air_or_ground_multiplier)

	new_x = clampf(new_x, -SAOwner.data.speed, SAOwner.data.speed)
	var ground_in_front = _detect_ground_in_front(edge_detector)
	if !ground_in_front: new_x = 0.0
	return new_x

func _detect_ground_in_front(_ray:RayCast2D) -> bool:
	_ray.force_raycast_update()
	return _ray.is_colliding()

func flip():
	if (SAOwner.sprite.flip_h and edge_detector.position.x > 0) or (!SAOwner.sprite.flip_h and edge_detector.position.x < 0):
		edge_detector.position.x = -edge_detector.position.x
