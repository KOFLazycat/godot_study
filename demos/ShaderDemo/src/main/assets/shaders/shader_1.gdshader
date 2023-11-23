shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	//COLOR = vec4(1.0, 0.0, 0.0, 0.1);
	COLOR = texture(TEXTURE, UV);
	//COLOR = COLOR * vec4(1.0, 0.0, 0.0, 0.1);// 调整图片颜色
	COLOR = vec4(COLOR.r, COLOR.g, COLOR.b, COLOR.b);// 单独提取某一个通道
}

void light() {
	// Called for every pixel for every light affecting the material.
}
