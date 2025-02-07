shader_type canvas_item;

uniform bool whiten = false;

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	if(whiten) {
		vec3 white = vec3(1.0, 1.0, 1.0);
		vec3 rgb = mix(texture_color.xyz, white, 0.6);
		COLOR = vec4(rgb, texture_color.a);
	}
}
