shader_type canvas_item;

uniform float IncreaseFactor : hint_range(0.0, 1.0);

void fragment() {
    // Gradually increase the red component until it reaches 1.0
    COLOR.r = min(COLOR.r + IncreaseFactor, 1.0);
    // Decrease the green and blue components
    COLOR.g = max(COLOR.g - IncreaseFactor, 0.0);
    COLOR.b =max(COLOR.b - IncreaseFactor, 0.0);
}