shader_type canvas_item;

uniform sampler2D img;
uniform float angle = 0.0;

vec2 custom_rotator(vec2 UVs, vec2 rotation_center, float rotation_angle) {
	// 自定义旋转数
	// UVs插入uv，世界坐标或其他值来旋转
	// rotation_center 输入一个点坐标作为旋转中心
	// rotation_angle 为旋转输入0-1个值，值为1等于360旋转
	vec2 _uv = UVs + rotation_center * -1.0;
	float angle_cos = cos(rotation_angle);
	float angle_sin = sin(rotation_angle);
	vec2 _a = vec2(angle_cos, angle_sin * -1.0);
	vec2 _b = vec2(angle_sin, angle_cos);
	
	return vec2(dot(_uv, _a), dot(_uv, _b)) + rotation_center;
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv_ = UV;
	//uv_ = uv_ - 0.5;
	//mat2 m = mat2(vec2(cos(angle), -sin(angle)), vec2(sin(angle), cos(angle)));
	//uv_ = uv_ * m;
	//uv_ = uv_ + 0.5;
	
	//uv_ = 1.0 - uv_;
	//uv_.x = 1.0 - uv_.x;
	
	uv_ = custom_rotator(uv_, vec2(0.5, 0.5), angle);
	
	COLOR = texture(img, uv_);
	//COLOR = vec4(uv_, 0.0, 1.0);
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
