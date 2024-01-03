shader_type spatial;
render_mode unshaded;

group_uniforms Dither;
uniform sampler2D _pattern : source_color, filter_nearest;
uniform float _thresh = 1.0;
uniform float _dither_scale = 1.0;

group_uniforms Pixelation;
uniform float _scale = 256.0;
uniform sampler2D _screen : hint_screen_texture, filter_nearest;

vec3 pixelate(sampler2D tex, vec2 uv) {
	uv = floor(uv * _scale) / _scale;
	return texture(tex, uv).rgb;
}

void vertex() {
	POSITION = vec4(VERTEX, 1.0);
}

void fragment() {
	vec3 p = pixelate(_pattern, SCREEN_UV * _dither_scale).rgb;
	vec3 s = pixelate(_screen, SCREEN_UV);
	vec3 o;
	if (length(s) > length(p) * _thresh)
		o = s;
	else
		o = vec3(0.0);
	ALBEDO = o;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
