shader_type spatial;
render_mode unshaded;

uniform sampler2D _pattern : source_color, filter_nearest;
uniform float _scale = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = texture(_pattern, UV * floor(_scale)).rgb;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
