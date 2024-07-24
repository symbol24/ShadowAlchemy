shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture, filter_nearest;
uniform vec2 lights[100];
uniform int number_of_lights = 1;
uniform vec4 modulate_color: source_color = vec4(0.0);
uniform float base_radius = 16;
uniform float band_radius = 10;
uniform float band_str = 0.3;


float distance_to_light(vec2 coords, vec2 _lights[100]){
	float dist = 1000.0;
	
	for (int i = 0; i < number_of_lights; i++){
		float new_dist = distance(coords, _lights[i]);
		
		if (new_dist < dist){
			dist = new_dist;
		}
	}
	return dist;
}

vec4 modulate(vec4 color, float distance_to){
	vec4 modulated = color * modulate_color;
	
	if (distance_to > base_radius){
		return modulated;
	}
	
	if (distance_to >= band_radius){
		return mix(modulated, color, band_str);
	}
	return color;
}

void fragment() {
	COLOR = texture(screen_texture, SCREEN_UV);
	COLOR = modulate(COLOR, distance_to_light(FRAGCOORD.xy, lights));
	
}