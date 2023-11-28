shader_type canvas_item;

uniform vec3      iResolution;           // viewport resolution (in pixels)
uniform float     iTime;                 // shader playback time (in seconds)
uniform float     iTimeDelta;            // render time (in seconds)
uniform float     iFrameRate;            // shader frame rate
uniform int       iFrame;                // shader playback frame
uniform float     iChannelTime[4];       // channel playback time (in seconds)
uniform vec3      iChannelResolution[4]; // channel resolution (in pixels)
uniform vec4      iMouse;                // mouse pixel coords. xy: current (if MLB down), zw: click
uniform sampler2D iChannel;          	 // input channel. XX = 2D/Cube
uniform vec4      iDate;                 // (year, month, day, time in seconds)
uniform float     iSampleRate;           // sound sample rate (i.e., 44100)

vec4 mainImage( in vec4 fragCoord )
{
	float aspect_ratio = iResolution.y/iResolution.x;
	vec2 uv = fragCoord.xy / iResolution.x;
	uv -= vec2(0.5, 0.5 * aspect_ratio);
	float rot = radians(-30. -iTime); // radians(45.0*sin(iTime));
	mat2 rotation_matrix = mat2(vec2(cos(rot), -sin(rot)), vec2(sin(rot), cos(rot)));
	uv = rotation_matrix * uv;
	vec2 scaled_uv = 20.0 * uv; 
	vec2 tile = fract(scaled_uv);
	float tile_dist = min(min(tile.x, 1.0-tile.x), min(tile.y, 1.0-tile.y));
	float square_dist = length(floor(scaled_uv));
	
	float edge = sin(iTime-square_dist*20.);
	edge = mod(edge * edge, edge / edge);

	float value = mix(tile_dist, 1.0-tile_dist, step(1.0, edge));
	edge = pow(abs(1.0-edge), 2.2) * 0.5;
	
	value = smoothstep( edge-0.05, edge, 0.95*value);
	
	value += square_dist*.1;
	value *= 0.8 - 0.2;
	return vec4(pow(value, 2.), pow(value, 1.5), pow(value, 1.2), 1.);
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 color = mainImage(FRAGCOORD);
	COLOR = vec4(color.r, color.g, color.b, color.a);
}

