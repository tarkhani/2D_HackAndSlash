shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

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

        // Make the grayscale color darker by multiplying it with a factor less than 1
        vec3 darker_grayscale_color = grayscale_color * 0.5; // Adjust the factor as needed for desired darkness

        // Set the output color to the darker grayscale color
        COLOR.rgb = darker_grayscale_color;
        COLOR.a = original_color.a; // Preserve alpha channel
    }
}