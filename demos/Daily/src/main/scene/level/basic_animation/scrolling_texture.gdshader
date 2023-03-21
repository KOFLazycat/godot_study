shader_type canvas_item;
uniform vec2 direction=vec2(1.0, 0.0);
uniform float speed = 0.1;

void fragment() {
	// Place fragment code here.
	vec2 move = direction*TIME*speed;
	COLOR = texture(TEXTURE, UV+move);
}
