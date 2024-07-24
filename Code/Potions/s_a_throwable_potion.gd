class_name SAThrowablePotion extends RigidBody2D

@export var data:PotionData
@onready var hit_detection:Area2D = %hit_detection

var break_once := false
var loaded = null

func _ready():
	hit_detection.body_entered.connect(_collision_detection)
	if data.hit_fx_path:
		loaded = load(data.hit_fx_path)
	

func _collision_detection(_area):
	for each in _area.get_groups():
		if each in ["ground", "enemy"]: 
			break_potion()
	
func break_potion():
	if !break_once:
		break_once = true
		spawn_hit_fx(data.hit_fx_path)
		spawn_particles(data.particle_path, data.particle_count)
		queue_free.call_deferred()

func spawn_particles(_path := "", _count := 1.0):
	if _path:
		var _loaded = load(_path)
		var direction = Vector2(0.1, -1)
		var split:float = 1/(_count+1)
		var x = 0
		while x < _count:
			var particle = _loaded.instantiate() as SAPotionParticle
			GameMode.world.add_child.call_deferred(particle)
			particle.global_position = global_position
			particle.apply_throw(direction)
			direction = Vector2(direction.x+split, -1)
			x += 1
		
		x = 0
		direction = Vector2(-split, -1)
		
		while x < _count:
			var particle = _loaded.instantiate() as SAPotionParticle
			GameMode.world.add_child.call_deferred(particle)
			particle.global_position = global_position
			particle.apply_throw(direction)
			direction = Vector2(direction.x-split, -1)
			x += 1
			
func spawn_hit_fx(_path:=""):
	if _path:
		var hit_fx = loaded.instantiate()
		hit_fx.global_position = global_position
		GameMode.world.add_child.call_deferred(hit_fx)
