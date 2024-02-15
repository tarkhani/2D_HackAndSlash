shader_type canvas_item;

uniform int enable_silhouette; // Enable or disable silhouette effect
uniform float jump_offset = 0.2; // Default offset for both left and right
uniform float offset_left = -0.1; // Offset for left silhouette
uniform vec4 silhouette_color: source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float IncreaseFactor : hint_range(0.0, 1.0);

void fragment() {
    // Gradually increase the red component until it reaches 1.0
	vec4 sil_color=silhouette_color;
    COLOR.r = min(COLOR.r + IncreaseFactor, 1.0);
	sil_color.r=min(sil_color.r + 3.0*IncreaseFactor, 1.0);
	
    // Decrease the green and blue components
    COLOR.g = max(COLOR.g - IncreaseFactor, 0.0);
	sil_color.g=min(sil_color.g - 3.0*IncreaseFactor, 1.0);
	
    COLOR.b = max(COLOR.b - IncreaseFactor, 0.0);
	sil_color.b=min(sil_color.b - 3.0*IncreaseFactor, 1.0);

    vec4 main_color = COLOR;
    vec4 silhouette_left = vec4(0.0, 0.0, 0.0, 0.0); // Initialize left silhouette color as transparent black

    // Check if silhouette effect is enabled
    if (enable_silhouette==1) {
        // Assuming jump_state is a uniform boolean indicating whether the character is jumping
            // Calculate the UV coordinates for the left silhouette
            vec2 silhouette_uv_left = UV + vec2(offset_left, 0.0); // Left of the character

            // Sample the color from the texture at the left silhouette UV coordinates
            silhouette_left = texture(TEXTURE, silhouette_uv_left);
        }
    

    // Mix the silhouette color with the main color based on its alpha component
    vec4 final_color = mix(main_color, sil_color, silhouette_left.a);

    // Output the final color
    COLOR = final_color;
}