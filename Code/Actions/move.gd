extends SAAction

var h_direction := 0.0
var v_direction := 0.0

func _physics_process(_delta):
	if SAOwner and GameMode.is_playing():
		h_direction = SAInput.move_left_right
		v_direction = SAInput.move_up_down
		
		var new_x = _walk_and_idle(_delta, h_direction)
		
		if SAOwner.can_move:
			SAOwner.velocity.x = new_x

func _walk_and_idle(_delta:= 0.0, _direction := 0.0) -> float:
	var new_x:float = SAOwner.velocity.x
	var air_or_ground_multiplier = 1.0
	#if !grounded: air_or_ground_multiplier = AIR_MULTIPLIER
	
	new_x = clampf(new_x, -SAOwner.data.speed, SAOwner.data.speed)
	
	if _direction > 0.1 or _direction < -0.1:
		#if SAOwner.grounded:
			#if state.check_current_state("idle"):
				#state.set_state("run")
				#update_animation("run1")
			
		new_x = move_toward(new_x, SAOwner.data.speed * _direction, _delta * SAOwner.data.acceleration * air_or_ground_multiplier)
		#can_play_walk = true
	else:
		#if grounded:
			#if state.check_current_state("run"):
				#state.set_state("idle")
				#update_animation("idle")
		
		new_x = move_toward(new_x, 0, _delta * SAOwner.data.friction * air_or_ground_multiplier)
		#can_play_walk = false
	return new_x
