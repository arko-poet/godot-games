shader_type canvas_item;

const float SHADING = 0.75;

uniform float progress: hint_range(0.0, 1.0) = 1.0;
uniform float item_rotation = 0.0;

void fragment() {
	// center UV before applying rotation
	vec2 centered_uv = UV - vec2(0.5);
	
	// rotate UV then uncenter (UV seems to be y-down coordinate system)
	// rotation is applied so that progress fill always happens vertically up
	float c = cos(item_rotation);
	float s = sin(item_rotation);
	vec2 rotated_uv = vec2(
		centered_uv.x * c - centered_uv.y * s,
		centered_uv.x * s + centered_uv.y * c
	) + vec2(0.5);

	// shade parts of texture above progress
	if (UV.y < (1.0 - progress)) {
		COLOR = vec4(COLOR.rgb * SHADING, COLOR.a);
	}
}
