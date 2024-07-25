extends SAEnemyAction

const PROJECTILE = preload("res://Scenes/FX/skeleton_mage_projectile.tscn")

@onready var attack_delay:Timer = %attack_delay

var attacking := false

func _ready():
	super._ready()
	attack_delay.timeout.connect(_timer_timeout)
	SASignals.EnemyAttackOver.connect(_reset_attack)
	SASignals.MageShoot.connect(_shoot)

func _physics_process(_delta):
	if GameMode.is_playing() and SAOwner and SAOwner.target:
		if !attacking and SAOwner.get_distance_to_target(SAOwner.target) <= SAOwner.data.attack_distance:
			attacking = true
			SASignals.EnemyAttack.emit(SAOwner)
			attack_delay.start()

func _reset_attack(_enemy:SAEnemy):
	if _enemy == SAOwner and attacking: attacking = false

func _shoot(_enemy:=""):
	if _enemy == SAOwner.name:
		var new_proj = PROJECTILE.instantiate()
		var direction = global_position.direction_to(SAOwner.target.global_position)
		new_proj.direction = direction.x
		if direction.x < 0.0:
			new_proj.flip()
		new_proj.global_position = SAOwner.projectile_point.global_position
		GameMode.world.add_child.call_deferred(new_proj)

func _timer_timeout():
	attacking = false
