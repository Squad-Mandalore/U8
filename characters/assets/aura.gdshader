shader_type spatial;
render_mode unshaded, depth_draw_always, cull_disabled;

uniform sampler2D sprite_texture: filter_nearest;
uniform vec4 aura_color : source_color = vec4(1.0, 0.8, 0.0, 1.0); // Yellow aura
uniform float aura_thickness = 2.0; // Pixel thickness of aura
uniform int aura_steps = 2; // More steps = smoother aura fill
uniform float aura_flicker_speed = 7.0; // Speed of aura flicker
uniform float aura_flicker_strength = 0.5; // Strength of flicker

void fragment() {
    vec2 texture_size = vec2(textureSize(sprite_texture, 0)); // Convert ivec2 to vec2
    vec2 pixel_size = vec2(1.0) / texture_size; // Get pixel size
    vec2 uv = UV;
    vec4 sprite_tex = texture(sprite_texture, uv);
    
    float edge = 0.0; // Stores how close we are to the sprite

    // MULTI-STEP EDGE DETECTION TO FILL AURA GAPS
    for (int i = 1; i <= aura_steps; i++) {
        float step_size = float(i) * (aura_thickness / float(aura_steps));

        vec2 uv_right  = clamp(uv + vec2(step_size * pixel_size.x, 0), vec2(0.0), vec2(1.0));
        vec2 uv_left   = clamp(uv - vec2(step_size * pixel_size.x, 0), vec2(0.0), vec2(1.0));
        vec2 uv_up     = clamp(uv + vec2(0, step_size * pixel_size.y), vec2(0.0), vec2(1.0));
        vec2 uv_down   = clamp(uv - vec2(0, step_size * pixel_size.y), vec2(0.0), vec2(1.0));

        edge = max(edge, texture(sprite_texture, uv_right).a);
        edge = max(edge, texture(sprite_texture, uv_left).a);
        edge = max(edge, texture(sprite_texture, uv_up).a);
        edge = max(edge, texture(sprite_texture, uv_down).a);
    }

    bool is_aura = (edge > 0.0) && (sprite_tex.a == 0.0) && (uv.y < 1.0);
    
    if (is_aura) {
        // Flicker effect
        float flicker = (sin(TIME * aura_flicker_speed + UV.y * 10.0) + 1.0) * 0.5 * aura_flicker_strength;
        ALBEDO = aura_color.rgb * (0.5 + flicker); // Base brightness + flicker
        ALPHA = aura_color.a * (0.5 + flicker);
    } else {
        // Normal sprite rendering
        ALBEDO = sprite_tex.rgb;
        ALPHA = sprite_tex.a;
    }
}
