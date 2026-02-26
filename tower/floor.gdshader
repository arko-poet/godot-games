shader_type canvas_item;

uniform vec4 fill_color : source_color = vec4(1, 0, 0, 1);

void fragment() {
	COLOR = texture(TEXTURE, UV);
	if (!(COLOR.a == 1.0 && COLOR.b == 1.0 && COLOR.r == 1.0 && COLOR.g == 1.0)){
		COLOR = fill_color;
	}
}
