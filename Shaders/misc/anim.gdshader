shader_type spatial;

void vertex() {
	mat3 xRot = mat3(
		vec3(1.0,0.0,0.0),
		vec3(0.0, cos(TIME), -sin(TIME)),
		vec3(0.0, sin(TIME), cos(TIME))
	);
	
	mat3 yRot = mat3(
		vec3(cos(TIME),0.0,sin(TIME)),
		vec3(0.0, 1.0, 0.0),
		vec3(-sin(TIME), 0.0, cos(TIME))
	);
	
	VERTEX = VERTEX * xRot * yRot;
	VERTEX.y += sin(TIME * 2.0) / 10.0;
	
	NORMAL = NORMAL * xRot * yRot;
	NORMAL.y += sin(TIME * 2.0) / 10.0;
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
