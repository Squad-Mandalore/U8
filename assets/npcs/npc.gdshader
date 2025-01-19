shader_type canvas_item;

// We'll remove the type hint to avoid localization or version issues.
uniform vec4 outline_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform float outline_thickness = 1.0;

void fragment() {
    // Sample this pixel.
    vec4 base_col = texture(TEXTURE, UV);

    // We'll define a temporary color that we'll assign at the end of the function.
    // By default, assume we discard (alpha=0).
    vec4 final_col = vec4(0.0);

    // If the sampled pixel is mostly opaque...
    if (base_col.a > 0.1) {
        // Just show the original sprite pixel.
        final_col = base_col;
    } else {
        // Otherwise, check a small 3x3 neighborhood for any opaque neighbors.
        vec2 pixel_size = TEXTURE_PIXEL_SIZE;
        bool is_outline = false;

        for (int i = -1; i <= 1; i++) {
            for (int j = -1; j <= 1; j++) {
                vec2 offset_uv = UV + vec2(float(i), float(j)) * pixel_size * outline_thickness;
                vec4 neighbor_col = texture(TEXTURE, offset_uv);
                if (neighbor_col.a > 0.1) {
                    is_outline = true;
                    // We can't `break` from both loops easily, but we can set the flag
                    // and continue scanning (or see tip below).
                }
            }
        }

        if (is_outline) {
            final_col = outline_color;
        } else {
            // This pixel has no opaque neighbors => fully transparent.
            // We'll handle it after the loop by discarding if alpha=0.
        }
    }

    // If final_col has alpha=0.0, we can discard it
    if (final_col.a <= 0.0) {
        discard;
    } else {
        COLOR = final_col;
    }
}
