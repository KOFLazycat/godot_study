shader_type canvas_item;

uniform vec3 iResolution; // viewport resolution (in pixels)
uniform float iTime; // shader playback time (in seconds)
uniform float iTimeDelta; // render time (in seconds)
uniform float iFrameRate; // shader frame rate
uniform int iFrame; // shader playback frame

vec4 mainImage( in vec2 fragCoord )
{
	// Normalized pixel coordinates (from 0 to 1)
	vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y;

	float waves1 = sin(uv.x * 8. + cos(uv.y * 4.) + iTime * 2.);
	float waves2 = sin(uv.y * 4. + cos(uv.x * 8.) + iTime * 2.);
	
	float circles = length(uv) - 0.5;
	circles = sin(circles * 8. + iTime*2.);
	circles = abs(circles);
	circles = smoothstep(0.002,1.,circles);
	circles = 0.05/circles;
	circles = pow(circles, 3.);
	float d = waves1 * waves2 * circles;

	// Output to screen
	return vec4(vec3(d,d,d),1.0);
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 color = mainImage(FRAGCOORD.xy);
	COLOR = vec4(color.r, color.g, color.b, color.a);
}

