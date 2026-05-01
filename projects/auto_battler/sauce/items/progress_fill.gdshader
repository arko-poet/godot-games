shader_type canvas_item;

const float SHADING = 0.75;
uniform float progress: hint_range(0.0, 1.0) = 1.0;

void fragment() {
	if (UV.y < (1.0 - progress)) {
		COLOR = vec4(COLOR.rgb, SHADING);
	}
}
