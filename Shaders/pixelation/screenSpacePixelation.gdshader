// made by: dan //
// pixelation effect
// create a quad and apply this shader to it
// in the quad, flip faces and scale it to (2,2)
shader_type spatial;
render_mode unshaded;

// references
// https://www.patrykgalach.com/2020/06/01/pixelated-effect-in-unity-shader-graph/#:~:text=To%20create%20a%20pixelated%20effect,back%20by%20the%20same%20value.

uniform float _scale = 256.0;
uniform sampler2D _screen : hint_screen_texture, filter_nearest;

vec3 pixelate(sampler2D tex, vec2 uv) {
	//uv *= _scale;
	//uv = floor(uv);
	//uv /= _scale;
	uv = floor(uv * _scale) / _scale;
	return texture(tex, uv).rgb;
}

void vertex() {
	POSITION = vec4(VERTEX, 1.0);
}

void fragment() {
	ALBEDO = pixelate(_screen, SCREEN_UV);
}
