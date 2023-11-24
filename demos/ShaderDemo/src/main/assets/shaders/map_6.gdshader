shader_type canvas_item;

uniform sampler2D img;
uniform float offset_x = 0.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv_ = UV;
	float x = uv_.x;
	float y = uv_.y;
	
	float x02 = uv_.x * 2.0;
	float id = floor(x02);// 向下取整
	float x0101 = x02 - id;
	
	float mask_x = step(x02, 1.0);
	float x0100 = x0101 * (1.0 - mask_x);
	float x1010 = 1.0 - x0101;
	float x0010 = x1010 * mask_x;
	
	float x0110 = x0100 + x0010;
	
	uv_ = vec2(x0110 + offset_x, y);
	
	// 确保图片不会有多余无用的像素
	if (any(greaterThan(abs(uv_ - 0.5), vec2(0.5)))) discard;
	
	COLOR = texture(img, uv_);
	//COLOR = vec4(x0110, y, 0.0, 1.0);
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
