shader_type canvas_item;
uniform sampler2D aaa;

void fragment() {
	// Place fragment code here.
//	COLOR = COLOR * vec4(1.0, 1.0, 0.0, 1.0);// 调整图片颜色
//	COLOR = vec4(COLOR.r, COLOR.g, COLOR.b, COLOR.b);// 单独提取某一个通道
//	COLOR = vec4(UV, 0.5, 1.0);
	vec2 uv = UV;
	uv = uv + 0.0;
	COLOR = texture(aaa, uv); //read from texture
}

void vertex() {
//  VERTEX += vec2(0, sin(TIME)*10.0);
}