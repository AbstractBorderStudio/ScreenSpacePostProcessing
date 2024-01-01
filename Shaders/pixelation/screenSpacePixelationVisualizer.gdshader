// made by: dan //
// pixelation effect visualizer tool
shader_type spatial;
render_mode unshaded;

uniform sampler2D _screen : source_color, hint_screen_texture, filter_nearest;
uniform float _scale = 256.0;
uniform bool _e_scale = false;
uniform bool _e_floor = false;
uniform bool _e_div = false;
uniform bool _e_screen = false;

vec3 pixelate(sampler2D tex, vec2 uv) {
	if (_e_scale) 
		uv *= _scale;
	if (_e_floor)
		uv = floor(uv);
	if (_e_div)
		uv /= _scale;
	return vec3(uv, 0.0);
}

void fragment() {
	if (!_e_screen)
		ALBEDO = pixelate(_screen, UV);
	else
		ALBEDO = pixelate(_screen, SCREEN_UV);
}
