extends SAAction

var jump_count := 1
var landed := false
var coyote_delay := 0.3
var coyote_timer := 0.0

func _ready():
	super._ready()
	if SAOwner: jump_count = SAOwner.data.jump_count
	else: print("Jump has no SAOwner?")
	SASignals.CharacterGrounded.connect(_set_landed)

func _physics_process(_delta):
	if SAOwner and GameMode.is_playing():
		if SAInput.action_1:
			jump()
		
		_check_falling(SAOwner.velocity.y)
		_coyote_time(_delta)

func jump():
	if jump_count > 0:
		landed = false
		jump_count -= 1
		SAOwner.velocity.y = SAOwner.get_jump_velocity()
		SASignals.UpdateCharaterState.emit(SACharacterBody2D.STATE.JUMPING)
		
func _set_landed(_character:SACharacterBody2D):
	if _character == SAOwner and !landed and _character.grounded:
		landed = true
		SASignals.UpdateCharaterState.emit(SACharacterBody2D.STATE.IDLE)
		jump_count = SAOwner.data.jump_count
		coyote_timer = 0.0

func _check_falling(_y := 0.0):
	if !landed and _y > 0.0:
		SASignals.UpdateCharaterState.emit(SACharacterBody2D.STATE.FALLING)
	elif !landed and _y < 0.0:
		SASignals.UpdateCharaterState.emit(SACharacterBody2D.STATE.JUMPING)

func _coyote_time(_delta := 0.0):
	if !landed:
		coyote_timer += _delta
		if coyote_timer >= coyote_delay:
			if jump_count == SAOwner.data.jump_count: jump_count -= 1
