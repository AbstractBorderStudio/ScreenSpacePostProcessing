shader_type spatial;
render_mode unshaded;

void vertex() {
	mat4 ortogonal = mat4(
		vec4((10.0+10.0)/2.0, 0.0, 0.0, 0.0),
		vec4(0.0, (10.0+10.0)/2.0, 0.0, 0.0),
		vec4(0.0, 0.0, (100.0 - 0.05)/-2.0, -(100.0 + 0.05)/2.0),
		vec4(0.0,0.0,0.0,1.0)
	);
	POSITION = vec4(VERTEX,1.0);
	//VERTEX = (INV_VIEW_MATRIX * INV_PROJECTION_MATRIX * vec4(VERTEX, 1.0)).rgb;
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
