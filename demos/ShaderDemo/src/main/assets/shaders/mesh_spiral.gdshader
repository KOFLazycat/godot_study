shader_type canvas_item;
//主贴图
uniform sampler2D MainTex;
//图像平铺值倍数
uniform vec2 Tiling = vec2(1.0,1.0)
;//图像尺寸
uniform vec2 ImgSize = vec2(1.0,1.0);
//图像偏移
uniform vec2 offset = vec2(0.0,0.0);
//主贴图速度
uniform vec2 MainTexPanner;

//主贴图颜色
uniform vec4 MainTexColor:source_color = vec4(1.0);
//主贴图明度(亮度)
uniform float MainTexBrightness = 1.0;
//主贴图对比度
uniform float MainTexContrast = 1.0;
//主贴图饱和度
uniform float MainTexSaturation = 1.0;
//遮罩贴图
uniform sampler2D MaskTex;
//遮罩图像平铺值倍数
uniform vec2 MaskTiling = vec2(1.0,1.0);
//遮罩图像尺寸
uniform vec2 MaskImgSize = vec2(1.0,1.0);
//遮罩图像偏移
uniform vec2 Maskoffset = vec2(0.0,0.0);
//扰动扭曲溶解贴图
uniform sampler2D TurbulenceTex;
//扰动扭曲图像平铺值倍数
uniform vec2 TurbulenceTiling = vec2(1.0,1.0);
//扰动扭曲图像尺寸
uniform vec2 TurbulenceImgSize = vec2(1.0,1.0);
//扰动扭曲图像偏移
uniform vec2 Turbulenceoffset = vec2(0.0,0.0);
//扰动强度
uniform float TurbulenceTexPower = 0.0;
//扰动速度
uniform vec2 TurbulencePanner;
//溶解强度
uniform float TurbulenceTexDis = 0.0;

vec3 lerp (vec3 a, vec3 b, float x)
{
	return a + x * (b - a);
}

void fragment(){
	vec2 mask_uv = UV;
	mask_uv.x = fract(mask_uv.x * MaskTiling.x + Maskoffset.x);
	mask_uv.y = fract(mask_uv.y * MaskTiling.y + Maskoffset.y);
	mask_uv.x = mask_uv.x * MaskImgSize.x;
	mask_uv.y = mask_uv.y * MaskImgSize.y;
	vec4 mask_color = texture(MaskTex,mask_uv);
	
	//扰动溶解贴图
	vec2 turbulence_uv = UV + TIME * TurbulencePanner;
	turbulence_uv.x = fract(turbulence_uv.x * TurbulenceTiling.x + Turbulenceoffset.x);
	turbulence_uv.y = fract(turbulence_uv.y * TurbulenceTiling.y + Turbulenceoffset.y);
	turbulence_uv.x = turbulence_uv.x * TurbulenceImgSize.x;
	turbulence_uv.y = turbulence_uv.y * TurbulenceImgSize.y;
	vec4 turbulence_color = texture(TurbulenceTex, turbulence_uv);
	turbulence_color = clamp(turbulence_color * TurbulenceTexPower, 0.0, 1.0);
	
	vec2 uv = UV + vec2(turbulence_color.r - TurbulenceTexPower/2.0,turbulence_color.r - TurbulenceTexPower/2.0);
	uv.x = fract(uv.x * Tiling.x + offset.x + TIME * MainTexPanner.x);
	uv.y = fract(uv.y * Tiling.y + offset.y + TIME * MainTexPanner.y);
	uv.x = uv.x * ImgSize.x;
	uv.y = uv.y * ImgSize.y;
	vec4 main_color = texture(MainTex,uv);
	
	// 调整主贴图颜色
	vec4 output_color = main_color * MainTexColor;
	output_color.a = output_color.a * mask_color.r;
	//溶解
	float turbulence_mask = step(TurbulenceTexDis,turbulence_color.r);
	output_color.a = clamp(output_color.a * turbulence_mask,0.0,1.0);
	// 调整亮度
	output_color.rgb = output_color.rgb * MainTexBrightness;
	// 调整对比度
	vec3 avg_color = vec3(0.5,0.5,0.5);
	output_color.rgb = lerp(avg_color,output_color.rgb,MainTexContrast);
	// 调整饱和度
	float luminance = 0.2125 * output_color.r + 0.7154 * output_color.g + 0.0721 * output_color.b;
	vec3 luminance_color = vec3(luminance);output_color.rgb = lerp(luminance_color,output_color.rgb,MainTexSaturation);
	COLOR = output_color;
	//COLOR = vec4(UV,0.0,1.0);
}
