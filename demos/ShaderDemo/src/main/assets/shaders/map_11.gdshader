shader_type canvas_item;

uniform float value;
uniform vec4 iMouse;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	COLOR = vec4(value, iMouse.r, iMouse.g, 1.0);
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
