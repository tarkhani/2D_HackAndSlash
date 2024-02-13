shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float distortion_strength : hint_range(0.0, 1.0);

void fragment() {
    // Get the UV coordinates of the current pixel
    vec2 uv = SCREEN_UV;

    // Calculate the distortion amount based on UV coordinates
    vec2 distortion = vec2(sin(uv.y * 100.0), cos(uv.x * 100.0)) * 0.02;

    // Apply the distortion to UV coordinates
    uv += distortion;

    // Sample the original color from the screen texture with distorted UV coordinates
    vec4 original_color = textureLod(screen_texture, uv, 0.0);

    // Set the output color
    COLOR = original_color;
}