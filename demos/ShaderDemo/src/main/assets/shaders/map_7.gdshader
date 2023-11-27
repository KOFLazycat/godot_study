shader_type canvas_item;
uniform float num = 6.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = UV;
	/*
	// 方法一
	float size = 5.0;
	uv = uv * size;
	float xOffset = step(fract(uv.y), 0.5) * 0.5;
	float xyOffset = step(fract(uv.x + xOffset), 0.5);
	COLOR = vec4(xyOffset, 0.0, 0.0, 1.0);
	*/
	/*
	// 方法二
	uv = sin(uv * 50.0);
	COLOR = vec4(ceil(uv.x * uv.y), 0.0, 0.0, 1.0);
	*/
	
	// 方法三
	uv = floor(uv * num);
	COLOR = vec4(mod(uv.x + uv.y, 2.0), 0.0, 0.0, 1.0);

	/*
	// 方法四
	float size = 30.0;
	uv = sin(uv * size);
	float x = 0.0;
	if (uv.x * uv.y > 0.0) {
		x = 1.0;
	}
	COLOR = vec4(x, 0.0, 0.0, 1.0);
	*/
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
