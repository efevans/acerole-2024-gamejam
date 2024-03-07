shader_type canvas_item;

uniform sampler2D transition_texture : filter_nearest;

void fragment() {
	vec4 transition_texture_color = texture(transition_texture, UV);
	
	if (transition_texture_color.r < .5) {
		COLOR.a = 0.0;
	}
}
