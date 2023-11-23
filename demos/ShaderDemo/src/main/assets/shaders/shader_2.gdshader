shader_type canvas_item;
uniform sampler2D aaa;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = UV;
	uv.x = uv.x + 0.1;
	COLOR = texture(aaa, uv);
}

void light() {
	// Called for every pixel for every light affecting the material.
}
