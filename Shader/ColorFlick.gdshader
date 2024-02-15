shader_type canvas_item;

uniform vec4 flash_color: source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float flash_mod : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec4 color = texture(TEXTURE, UV);
	
	if (color.a > 0.0) {
        // Calculate the final color with flash effect
        vec4 final_color = mix(color, flash_color, flash_mod);
        
        // Output the final color
        COLOR = final_color;
	}
}
