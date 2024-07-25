class_name SAEnemy extends SACharacterBody2D

var attacking := false
var target:SAMainCharacter

func _ready():
	super._ready()
	SASignals.EnemyAttack.connect(_trigger_attack)

func _process(_delta):
	if !target and GameMode.character: target = GameMode.character

func character_dead():
	queue_free.call_deferred()

func _trigger_attack(_enemy:SAEnemy):
	if _enemy == self:
		_update_state(name, STATE.ATTACKING)
		_update_animation(name, "attack")
		
func get_distance_to_target(_target:SAMainCharacter = null) -> float:
	if _target:
		#print(global_position.distance_squared_to(_target.global_position))
		return global_position.distance_squared_to(_target.global_position)
	
	return 10000000

func _hit_detection(_area):
	if _area.has_method("get_damages"):
		data.receive_damage(_area.get_damages())
