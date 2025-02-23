extends Npc
class_name SeatedNpc

var _animation_name: String = ""  
var _base_animation: String = ""  
var _animation_variants: Array = []  # Stores all available variants

func subclass_ready():
    if randi_range(0,5) == 1:
        self.collision_layer = 0
        self.collision_mask = 0
        queue_free()
        return 

    if randi_range(0, 1) == 1:
        _sprite.flip_h = true

    var animation_names = _sprite.sprite_frames.get_animation_names()
    var unique_animations = {}

    # Extract unique base animation names
    for anim in animation_names:
        var base_name = anim.rstrip("0123456789")
        if base_name in unique_animations:
            unique_animations[base_name].append(anim)
        else:
            unique_animations[base_name] = [anim]
    var base_keys = unique_animations.keys()
    _base_animation = base_keys[randi_range(0, base_keys.size() - 1)]
    _animation_variants = unique_animations[_base_animation]

    # Pick the default animation:
    if _base_animation + "1" in _animation_variants:
        _animation_name = _base_animation + "1"  # Use X1 as base animation
    else:
        _animation_name = _base_animation

    _sprite.play(_animation_name)

func make_space(body : Node2D) -> void:
    return

func set_player_nearby(is_player_nearby : bool):
    _player_nearby = is_player_nearby

func _on_animated_sprite_2d_animation_looped() -> void:
    if _animation_variants.size() == 1:
        return  # No variations, do nothing

    # If currently on X1 animation, randomly switch
    if _animation_name.ends_with("1"):
        if randi_range(1, 10) == 1:
            var new_animation = _pick_random_variant()
            if new_animation:
                _animation_name = new_animation
                _sprite.play(_animation_name)
    else:
        # Always return to `X1` after playing any variant
        _animation_name = _base_animation + "1"
        _sprite.play(_animation_name)

func _pick_random_variant() -> String:
    var possible_variations = _animation_variants.duplicate()

    if _base_animation + "1" in possible_variations:
        possible_variations.erase(_base_animation + "1")

    if possible_variations.size() > 0:
        return possible_variations[randi_range(0, possible_variations.size() - 1)]
    
    return _animation_name
