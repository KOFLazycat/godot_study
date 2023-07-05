shader_type canvas_item;

uniform bool open = false;
uniform vec4 color:source_color;

void fragment() {
	// Place fragment code here.
	if(open) {
		if (texture(TEXTURE, UV).a > 0.){
			COLOR = color;
		}
	}
}
