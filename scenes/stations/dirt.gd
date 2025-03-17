extends Sprite2D

@export var dirt_intensity: float = 0.3
@export var puddle_intensity: float = 0.9
@export var trash_intensity: float = 0.8

var dirt_texture: ImageTexture

func _ready():
    if texture:
        dirt_texture = generate_dirt_texture(texture)
        self.texture = dirt_texture

func generate_dirt_texture(base_texture: Texture) -> ImageTexture:
    var base_image = base_texture.get_image()
    var width = base_image.get_width()
    var height = base_image.get_height()

    randomize()  # Ensure different results on each run

    # **1️⃣ Setup Noises (Only if Enabled, Scaled by Intensity)**
    var dirt_noise: FastNoiseLite = null
    if dirt_intensity > 0.0:
        dirt_noise = FastNoiseLite.new()
        dirt_noise.seed = randi()
        dirt_noise.frequency = 0.02
        dirt_noise.noise_type = FastNoiseLite.TYPE_PERLIN
        
    var puddle_noise: FastNoiseLite = null
    if puddle_intensity > 0.0:
        puddle_noise = FastNoiseLite.new()
        puddle_noise.seed = randi()
        puddle_noise.frequency = 0.02
        puddle_noise.noise_type = FastNoiseLite.TYPE_PERLIN
        
    var trash_noise: FastNoiseLite = null
    if trash_intensity > 0.0:
        trash_noise = FastNoiseLite.new()
        trash_noise.seed = randi()
        trash_noise.frequency = 0.03
        trash_noise.noise_type = FastNoiseLite.TYPE_PERLIN

    # Store colors per pixel to ensure connected patches have the same color
    var puddle_colors = {}
    var trash_colors = {}
    
    # **2️⃣ Process Pixels**
    for y in range(height):
        for x in range(width):
            var base_color = base_image.get_pixel(x, y)
            if base_color.a == 0.0:
                continue  # Skip transparent pixels

            ### **Apply Dirt Smudges (Soft Brown)**
            if dirt_noise:
                var dirt_value = dirt_noise.get_noise_2d(x, y) * dirt_intensity
                if dirt_value > 0.05 * (1.0 - dirt_intensity):  # More intensity = lower threshold
                    var dirt_color = Color(0.6, 0.5, 0.3, dirt_value * 0.3 * dirt_intensity)
                    base_color = base_color.lerp(dirt_color, dirt_value)

            ### **Apply Puddles (Multiply Blend, Connected Regions Share the Same Color)**
            if puddle_noise:
                var puddle_value = puddle_noise.get_noise_2d(x, y)
                var puddle_threshold = 1 - puddle_intensity

                if puddle_value > puddle_threshold:
                    var coord = Vector2(x, y)

                    # Check if neighboring pixels already have a puddle color assigned
                    var neighbor_colors = []
                    for offset in [Vector2(-1, 0), Vector2(1, 0), Vector2(0, -1), Vector2(0, 1)]:
                        var neighbor_coord = coord + offset
                        if puddle_colors.has(neighbor_coord):
                            neighbor_colors.append(puddle_colors[neighbor_coord])

                    var puddle_color = neighbor_colors.pick_random() if neighbor_colors.size() > 0 else Color(randf_range(0.75, 1.0), randf_range(0.6,0.9), randf_range(0.1,0.2), puddle_intensity)

                    # Store the puddle color for this pixel
                    puddle_colors[coord] = puddle_color

                    # Multiply blend with base color
                    base_color = base_color * puddle_color  # **Multiplication ensures blending**

            ### **Apply Trash Objects (Scattered, Normal Blend, Some Random Variation)**
            if trash_noise:
                var trash_value = trash_noise.get_noise_2d(x, y)
                var trash_threshold = 1 - trash_intensity

                if trash_value > trash_threshold:
                    var coord = Vector2(x, y)

                    # Check if neighboring pixels already have a trash color assigned
                    var neighbor_colors = []
                    for offset in [Vector2(-1, 0), Vector2(1, 0), Vector2(0, -1), Vector2(0, 1)]:
                        var neighbor_coord = coord + offset
                        if trash_colors.has(neighbor_coord):
                            neighbor_colors.append(trash_colors[neighbor_coord])

                    # Occasionally allow a completely new trash color
                    var new_trash_color = false
                    if randi_range(0, 10) == 1:  # **10% chance for unique trash pixels**
                        new_trash_color = true

                    # Define different trash objects
                    var trash_palette = [
                        Color(0.5, 0.3, 0.2, trash_intensity),  # Bottle (brownish)
                        Color(0.7, 0.7, 0.7, trash_intensity),  # Paper (grayish)
                        Color(0.3, 0.3, 0.3, trash_intensity)   # Dark debris
                    ]
                    
                    var trash_color = trash_palette[randi() % trash_palette.size()] if new_trash_color or neighbor_colors.size() == 0 else neighbor_colors.pick_random()

                    # Store trash color
                    trash_colors[coord] = trash_color

                    # Trash remains in normal blend mode
                    base_color = trash_color

            base_image.set_pixel(x, y, base_color)

    var texture = ImageTexture.create_from_image(base_image)
    return texture
