shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture;
uniform float mix_val: hint_range(0.0, 1.0) = 1.0;

void fragment() {
	vec4 main_tx = texture(screen_texture, SCREEN_UV);
    float avg = (main_tx.r + main_tx.g + main_tx.b) / 3.0;
	COLOR.rgb = mix(main_tx.rgb, vec3(avg), mix_val);
}