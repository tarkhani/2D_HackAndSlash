shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float saturation_factor : hint_range(0.0, 1.0);

void fragment() {
    // Sample the original color from the screen texture
    vec4 original_color = textureLod(screen_texture, SCREEN_UV, 0.0);

    // Check if the red component of the original color is already 1.0
    if (original_color.r >= 0.8) {
        // If it is, set the output color to the original color
        COLOR = original_color;
    } else {
        // Otherwise, convert the color to grayscale
        float luminance = dot(original_color.rgb, vec3(0.2126, 0.7152, 0.0722));
        vec3 grayscale_color = vec3(luminance);
		grayscale_color = grayscale_color * 0.5;

        // Interpolate between grayscale and original color based on saturation factor
        vec3 interpolated_color = mix(grayscale_color, original_color.rgb, saturation_factor);

        // Set the output color
        COLOR.rgb = interpolated_color;
        COLOR.a = original_color.a; // Preserve alpha channel
    }
}