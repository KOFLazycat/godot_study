shader_type canvas_item;
//The Uniforms are detailed below:
//
//color1 – The primary color for the fire effect
//color2 – The secondary color for the fire effect
//brightness – Changes the size of the flame
//timeOffset – Gives variation to the flame (if you have more than one)
//timeRate – The speed at which the flame changes (due to noise)
//noiseAmmount – The noisey-ness of the flame. Adds more detail
//offsetX – Similar to timeOffset
//flickerT – A float between 0 and 1. Specifies the ammout the flame will flicker. Lower numbers cause more flickering.
//noise – Input NoiseTexture for variation and flickering

//Put this shader onto a ColorRect of the size you want (16×16 recommended). Choose your colors, brightness, and add the input noise. Then, tweak the variables until it looks right!

uniform vec4 color1 : source_color;
uniform vec4 color2 : source_color;
uniform float brightness = 0.0;
uniform sampler2D noise;
uniform float timeOffset = 0.0;
uniform float timeRate = 1.0;
uniform float noiseAmmount = 0.1;

uniform float offsetX = 0.0;

uniform float flickerT = 0.6;

vec4 lerp(vec4 col1, vec4 col2, float t) {
	float r = (col2.r - col1.r) * t + col1.r;
	float g = (col2.g - col1.g) * t + col1.g;
	float b = (col2.b - col1.b) * t + col1.b;
	return vec4(r, g, b, col1.a);
}

void fragment() {
	COLOR = lerp(color1, color2, texture(noise, UV).r);
	float dist = 1.0 - sqrt(pow(UV.x - 0.5, 2.0) + pow(UV.y - 0.5, 2.0));
	float flickerValue = texture(noise, vec2(TIME + timeOffset, (TIME + timeOffset) * 0.9)).r;
	if (flickerValue > flickerT) {
		dist *= flickerValue / (1.0 - flickerT) * 0.62;
	}
	COLOR.a *= dist + cos(UV.x * 10.0 + TIME * timeRate + timeOffset + offsetX) * 0.02 + brightness + cos(TIME * timeRate * 2.0 + timeOffset * 2.0) * 0.03;
	COLOR.a = (COLOR.a * (2.0 - noiseAmmount) + texture(noise, vec2(UV.x + timeOffset * -0.1 + TIME * timeRate * -0.1 + offsetX, UV.y) + brightness * 4.0).r * noiseAmmount) / 2.0;
	COLOR.a = round(COLOR.a * 20.0) / 20.0;
	COLOR.a = clamp(COLOR.a, 0.0, 1.0);
}