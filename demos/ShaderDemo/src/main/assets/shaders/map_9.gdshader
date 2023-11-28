shader_type canvas_item;
uniform sampler2D img;

float circle(vec2 position, float radius, float feather)
{
	return smoothstep(radius, radius + feather, length(position - vec2(0.5)));
}

vec4 square_rounded(vec2 uv, float width, float radius){
	uv = uv * 2.0 - 1.0;
	
	radius *= width; // make radius go from 0-1 instead of 0-width
	vec2 abs_uv = abs(uv.xy) - radius;
	vec2 dist = vec2(max(abs_uv.xy, 0.0));
	float square = step(width - radius, length(dist));
	return vec4(vec3(square), 1.0);
}

void fragment() {
	// Called for every pixel the material is visible on.
	/*
	// 圆形遮罩
	vec2 uv = UV;
	uv = uv - 0.5;
	float d = length(uv)*3.0;
	d = clamp(d, 0.0, 1.0);
	COLOR = vec4(d, 0.0, 0.0, 1.0);
	vec4 color = texture(img, UV);
	COLOR = vec4(color.r, color.g, color.b, 1.0 - d);
	*/
	/*
	// 圆形遮罩
	float d = circle(UV, 0.2, 0.005);
	vec4 color = texture(img, UV);
	COLOR = vec4(color.r, color.g, color.b, 1.0 - d);
	*/
	// 圆角方形遮罩
	vec4 d = square_rounded(UV, 0.8, 0.6);
	vec4 color = texture(img, UV);
	COLOR = vec4(color.r, color.g, color.b, 1.0 - d.r);
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
