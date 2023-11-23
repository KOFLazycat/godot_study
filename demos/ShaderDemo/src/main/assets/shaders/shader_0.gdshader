shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
	COLOR = vec4(1.0, 1.0, 0.0, 1.0);
}

void fragment() {
	// Called for every pixel the material is visible on.
}

void light() {
	// Called for every pixel for every light affecting the material.
}
