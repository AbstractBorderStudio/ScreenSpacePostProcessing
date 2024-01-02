shader_type spatial;

uniform float _scale = 0.0;

uniform sampler2D _tex;
uniform vec3 _base_col : source_color = vec3(1.0);

uniform sampler2D _cel_tex;
uniform float _edge0 = 0.0;
uniform float _edge1 = 0.01;
uniform float _glossiness = 1.0;
//uniform float _edge2 = 1.0;

uniform vec3 _specular_col : source_color = vec3(1.0);


uniform float _rim_att = 0.1;
uniform float _rim_size = 0.7;
uniform vec3 _rim_col : source_color = vec3(1.0);

void vertex() {
	VERTEX += VERTEX * NORMAL * _scale;
}

void fragment() {
	ALBEDO = _base_col;
}

void light() {
	// diffuse
	float col = 0.0;
	vec3 n_normal = normalize(NORMAL);
	float NdotL = normalize(dot(LIGHT, n_normal));
	float lightInt = smoothstep(_edge0, _edge1, NdotL);
	
	// specular highlighting
	vec3 H = normalize(LIGHT + VIEW);
	float NdotH = dot(n_normal, H);
	float specularInt = pow(NdotH * lightInt, _glossiness * _glossiness);
	float specularIntSmooth = smoothstep(0.005, 0.01, specularInt);

	// rim
	float rim_highlight = 1.0 - dot(VIEW, n_normal);
	float rim_int = rim_highlight * pow(NdotH, _rim_att);
	vec3 rim = vec3(smoothstep(_rim_size - 0.01, _rim_size + 0.01, rim_int)) * _rim_col;
	
	DIFFUSE_LIGHT = vec3(lightInt) + rim;
	SPECULAR_LIGHT = (specularIntSmooth * _specular_col);
}
