shader_type canvas_item;

uniform float fade_start : hint_range(0.0, 1.0) = 0.15; // Start fading at 75% of the width
uniform float fade_end : hint_range(0.0, 1.0) = 1.0;   // Fully faded at 100% of the width

uniform vec4 color : source_color;

void fragment() {
    // Equivalent to an empty fragment() function, since COLOR is also the output variable.
    float alpha_factor = smoothstep(fade_start, fade_end, UV.x);
    COLOR = color;
    COLOR.a *= alpha_factor; // Reduce alpha based on UV.x
}
