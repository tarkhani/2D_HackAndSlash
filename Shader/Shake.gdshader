shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float shake_strength : hint_range(0.0, 1.0);

void fragment() {
    // Get the UV coordinates of the current pixel
    vec2 uv = SCREEN_UV;

    // Calculate random offsets for screen shake
    float offsetX = (fract(sin(dot(uv + vec2(1.0, 2.0), vec2(12.9898, 78.233))) * 43758.5453) * 2.0 - 1.0) * 0.01;
    float offsetY = (fract(sin(dot(uv + vec2(4.0, 3.0), vec2(12.9898, 78.233))) * 43758.5453) * 2.0 - 1.0) * 0.01;

    // Apply screen shake by offsetting UV coordinates
    uv += vec2(offsetX, offsetY);

    // Sample the original color from the screen texture with the shaken UV coordinates
    vec4 original_color = textureLod(screen_texture, uv, 0.0);

    // Set the output color
    COLOR = original_color;
}