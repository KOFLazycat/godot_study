shader_type canvas_item;

uniform float fill_v: hint_range(0.0, 1.0, 0.01);
uniform vec4 color: source_color;

void fragment() {
	
	vec4 in_tex = texture(TEXTURE, UV);
	
	COLOR = color;
	COLOR.a = color.a * in_tex.a * (1.0 - step(UV.y, fill_v));
}
