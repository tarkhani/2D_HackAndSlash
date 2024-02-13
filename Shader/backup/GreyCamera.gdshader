shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
    vec3 c = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;

    float luminance = dot(c, vec3(0.2126, 0.7152, 0.0722));
    c = vec3(luminance);

    COLOR.rgb = c;
}