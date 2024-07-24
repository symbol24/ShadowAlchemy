class_name Lighting extends ColorRect

const PARTICLE = preload("res://Textures/z_potion_base_particle.png")

var start_delay := 0.5
var timer := 0.0
var delay_over := false

func _ready():
	show()
	
func _process(_delta):
	if !delay_over:
		timer += _delta
		if timer >= start_delay:
			delay_over = true
	else:
		var light_positions = _get_light_positions("light")
		material.set_shader_parameter("number_of_lights", light_positions.size())
		material.set_shader_parameter("lights", light_positions)

func _get_light_positions(_group := ""):
	return get_tree().get_nodes_in_group(_group).map(
		func(light: Node2D):
			#print(light.get_global_transform_with_canvas().get_origin())
			return light.get_global_transform_with_canvas().origin
	)
