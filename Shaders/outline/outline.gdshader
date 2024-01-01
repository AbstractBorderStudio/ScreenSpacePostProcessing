shader_type spatial;
render_mode unshaded;

// author: https://roystan.net/articles/outline-shader/

uniform sampler2D _depth : source_color, hint_depth_texture, filter_linear;
uniform sampler2D _normal : source_color, hint_normal_roughness_texture, filter_linear;
uniform float _Scale = 1.0;
uniform float _DepthThreshold = 1.0;
uniform float _NormalThreshold = 1.0;

float outline(vec2 screen_uv, vec2 screen_size) {
	float halfScaleFloor = floor(_Scale * 0.5);
	float halfScaleCeil = ceil(_Scale * 0.5);

	vec2 bottomLeftUV = screen_uv - vec2(screen_size.x, screen_size.y) * halfScaleFloor;
	vec2 topRightUV = screen_uv + vec2(screen_size.x, screen_size.y) * halfScaleCeil;  
	vec2 bottomRightUV = screen_uv + vec2(screen_size.x * halfScaleCeil, -screen_size.y * halfScaleFloor);
	vec2 topLeftUV = screen_uv + vec2(-screen_size.x * halfScaleFloor, screen_size.y * halfScaleCeil);
	
	// Add to the fragment shader, just below float2 topLeftUV.
	float depth0 = 1.0 - texture(_depth, bottomLeftUV).r;
	float depth1 = 1.0 - texture(_depth, topRightUV).r;
	float depth2 = 1.0 - texture(_depth, bottomRightUV).r;
	float depth3 = 1.0 - texture(_depth, topLeftUV).r;

	// Add above the return depth0 line.
	float depthFiniteDifference0 = depth1 - depth0;
	float depthFiniteDifference1 = depth3 - depth2;

	// Add below the lines computing the finite differences.			
	float edgeDepth = sqrt(pow(depthFiniteDifference0, 2.0) + pow(depthFiniteDifference1, 2)) * 100.0;

	// Add below the line declaring edgeDepth.
	float depthThreshold = _DepthThreshold * depth0;
	edgeDepth = edgeDepth > depthThreshold ? 1.0 : 0.0;
	// Add as a new variable.
	
	
	// ----------------- normal
	vec3 normal0 = texture(_normal, bottomLeftUV).rgb;
	vec3 normal1 = texture(_normal, topRightUV).rgb;
	vec3 normal2 = texture(_normal, bottomRightUV).rgb;
	vec3 normal3 = texture(_normal, topLeftUV).rgb;
	
	// Add below the code sampling the normals.				
	vec3 normalFiniteDifference0 = normal1 - normal0;
	vec3 normalFiniteDifference1 = normal3 - normal2;

	float edgeNormal = sqrt(dot(normalFiniteDifference0, normalFiniteDifference0) + dot(normalFiniteDifference1, normalFiniteDifference1));
	edgeNormal = edgeNormal > _NormalThreshold ? 1.0 : 0.0;
	
	// Add at the bottom, just above the line declaring float4 color.
	float edge = max(edgeDepth, edgeNormal);
	return edge;
}

void vertex() {
	POSITION = vec4(VERTEX, 1.0);
}

void fragment() {
	float o = outline(SCREEN_UV, VIEWPORT_SIZE);
	ALBEDO = vec3(o);
}
