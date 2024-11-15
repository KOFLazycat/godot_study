shader_type canvas_item;
uniform sampler2D img;

void vertex() {
	// Called for every vertex the material is visible on.
}

vec2 flipbook(vec2 uv, vec2 size, float progress){
	progress = floor( mod(progress, (size.x * size.y)) );
	vec2 frame_size = vec2(1.0, 1.0) / vec2(size.x, size.y);
	vec2 frame = fract(uv / size) + frame_size;

	frame.x += ( (progress / size.x) - frame_size.x * floor(progress/size.x) * size.x ) - frame_size.x;
	frame.y += (frame_size.y * floor(progress/size.x) ) - frame_size.y ;

	return frame;
}

void fragment()
{
	vec2 flip_uv = flipbook(UV, vec2(5.0, 5.0), TIME * 20.);
	vec4 flip_texture = texture(img, flip_uv);
	COLOR = flip_texture;
}

