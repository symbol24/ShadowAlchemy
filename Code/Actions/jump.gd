extends SAAction

var jump_count = 1
var landed = false

func _ready():
	super._ready()
	if SAOwner: jump_count = SAOwner.data.jump_count
	else: print("Jump has no SAOwner?")
	SASignals.CharacterGrounded.connect(set_landed)

func _physics_process(_delta):
	if SAOwner and GameMode.is_playing():
		if SAInput.action_1:
			jump()

func jump():
	if jump_count > 0:
		landed = false
		jump_count -= 1
		SAOwner.velocity.y = SAOwner.get_jump_velocity()
		
func set_landed(_character:SACharacterBody2D):
	if _character == SAOwner and !landed and _character.grounded:
		landed = true
		jump_count = SAOwner.data.jump_count
