extends SAEnemyAction

@onready var attack_delay:Timer = %attack_delay

var attacking := false

func _ready():
	super._ready()
	attack_delay.timeout.connect(_reset_attack)

func _physics_process(_delta):
	if GameMode.is_playing() and SAOwner and SAOwner.target and !SAOwner.is_dead():
		if !attacking and SAOwner.get_distance_to_target(SAOwner.target) <= SAOwner.data.attack_distance:
			attacking = true
			SASignals.EnemyAttack.emit(SAOwner)
			attack_delay.start()

func _reset_attack():
	if attacking: attacking = false
