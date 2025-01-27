shader_type canvas_item;

// The overall wave/vignette/blur intensity (0..3).
uniform float wave_intensity : hint_range(0, 3) = 0.0;

// Time offset from GDScript (_accum_time).
uniform float offset_time : hint_range(0, 999999) = 0.0;

void fragment()
{
    // wave_time from your script's offset_time:
    float wave_time = offset_time;

    // Wave calculations
    float frequency = 8.0 + 4.0 * wave_intensity;
    float amplitude = 0.01 * wave_intensity;

    // Slight blur
    float blur_radius = 0.0002 * wave_intensity;
    vec4 sum = vec4(0.0);

    // Reduced pincushion distortion strength with milder effect
    float k = -0.03 * wave_intensity;

    vec2 offsets[9] = vec2[](
        vec2(-1.0,  0.0),
        vec2( 1.0,  0.0),
        vec2( 0.0, -1.0),
        vec2( 0.0,  1.0),
        vec2(-1.0, -1.0),
        vec2(-1.0,  1.0),
        vec2( 1.0, -1.0),
        vec2( 1.0,  1.0),
        vec2( 0.0,  0.0)
    );

    for (int i = 0; i < 9; i++)
    {
        // Base sample position:
        vec2 sample_uv = UV + offsets[i] * blur_radius;
        
        // 1) Reduced Pincushion distortion:
        vec2 center = vec2(0.5, 0.5);
        vec2 coord = sample_uv - center;
        float r = length(coord);
        float r2 = r * (1.0 + k * r * r);
        coord = normalize(coord) * r2;
        sample_uv = center + coord;

        // 2) Wave distortion:
        sample_uv.x += amplitude * sin(sample_uv.y * frequency + wave_time * 3.0);

        // 3) Edge Stretching Effect:
        // Prevent seeing outside the screen by compressing near edges
        float edge_stretch_factor = 0.1 * wave_intensity; // Amount of stretch based on intensity
        sample_uv.x = mix(sample_uv.x, clamp(sample_uv.x, 0.05, 0.95), edge_stretch_factor);
        sample_uv.y = mix(sample_uv.y, clamp(sample_uv.y, 0.05, 0.95), edge_stretch_factor);

        sum += texture(TEXTURE, sample_uv);
    }
    vec4 color = sum / 9.0;

    // Vignette to black
    float vignette_strength = wave_intensity / 3.0;
    vec2 center_uv = vec2(0.5, 0.5);
    float dist = distance(UV, center_uv);
    float vignette = smoothstep(0.3, 0.7, dist);
    color = mix(color, vec4(0.0, 0.0, 0.0, 1.0), vignette * vignette_strength);
    COLOR = color;
}
