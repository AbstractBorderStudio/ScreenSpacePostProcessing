// made by: dan //
// pixelation effect
// appply to mesh material to pixelate it's texture
shader_type spatial;

uniform sampler2D _tex : source_color, filter_nearest;
uniform float _scale = 256.0;

vec3 pixelate(sampler2D tex, vec2 uv) {
	uv = floor(uv * _scale) / _scale;
	return texture(tex, uv).rgb;
}

void vertex() {
	//POSITION = vec4(VERTEX, 1.0);
}

void fragment() {
	ALBEDO = pixelate(_tex, UV);
}
