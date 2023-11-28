shader_type canvas_item;

uniform float iTime : hint_range(0.0, 1.0);
uniform sampler2D curve;
uniform sampler2D color_length;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	//vec4 curve_value = texture(curve, vec2(iTime, 0.0));
	//COLOR = vec4(curve_value.r, 0.0, 0.0, 1.0);
	
	vec4 curve_value = texture(color_length, vec2(iTime, 0.0));
	COLOR = vec4(curve_value.r, curve_value.g, curve_value.b, curve_value.a);
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
