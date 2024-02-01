shader_type spatial;
render_mode unshaded;

group_uniforms Misc;
uniform vec3 _shadow_col : source_color = vec3(0.0);
uniform float _shadow_strength = 1.0;

group_uniforms Pixelation;
uniform float _scale = 256.0;
uniform sampler2D _screen : hint_screen_texture, filter_nearest;
group_uniforms Dither;
uniform sampler2D _pattern : source_color, filter_nearest, repeat_enable;
uniform sampler2D _noise : source_color, filter_nearest;
uniform float _thresh = 1.0;
uniform float _dither_scale = 1.0;
uniform int bits = 1;

vec3 pixelate(sampler2D tex, vec2 uv) {
	uv = floor(uv * _scale) / _scale;
	return texture(tex, uv).rgb;
}

void vertex() {
	// set the quad full screen
	POSITION = vec4(VERTEX, 1.0);
}

void fragment() {
	vec4 p_s = textureProj(_pattern, vec3(1.0));
	
	
	vec2 ratio = normalize(VIEWPORT_SIZE);
	vec3 p = texture(_pattern, SCREEN_UV * ratio / _dither_scale).rgb;
	vec3 n = texture(_noise, SCREEN_UV * ratio * _dither_scale).rgb;
	vec3 s = pixelate(_screen, SCREEN_UV);
	float lum = (s.r * 0.299) + (s.g * 0.587) + (s.b * 0.114);
	float sh = (p.r * 0.299) + (p.g * 0.587) + (p.b * 0.114);
	float nh = (n.r * 0.299) + (n.g * 0.587) + (n.b * 0.114);
	
	lum = floor(lum * float(bits)) / float(bits);
	
	vec3 o;
	if (lum > sh * _thresh) {
		o = s;
	}
	else {
		o = _shadow_col * _shadow_strength;
	}
	ALBEDO = o;
	
	//ALBEDO = textureProj(_screen, 1.0 -VERTEX).rgb;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
