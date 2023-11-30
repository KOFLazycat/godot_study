shader_type canvas_item;
uniform float size:hint_range(0.0, 1.0, 0.1);


void fragment() {
	// Called for every pixel the material is visible on.
	float a = length(UV - 0.5);
	float b = 1.0 - smoothstep(0.0, size, a);
	COLOR = vec4(COLOR.r, COLOR.g, COLOR.b, b * COLOR.a);
}

