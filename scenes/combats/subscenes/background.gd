extends Sprite3D
class_name FightBackground

@onready var wall_left: Sprite3D = $WallLeft
@onready var wall_behind: Sprite3D = $WallBehind

# Müsste Funktionieren, nicht getestet da keine anderen bahnhöfe
func set_textures(new_wall_left: Texture2D, new_wall_behind: Texture2D, new_floor: Texture2D) -> void:
    update_sprite_texture(self, new_floor)
    update_sprite_texture(wall_left, new_wall_left)
    update_sprite_texture(wall_behind, new_wall_behind)

func update_sprite_texture(sprite: Sprite3D, texture: Texture2D) -> void:
    if sprite.material_override == null:
        sprite.material_override = StandardMaterial3D.new()
    var material = sprite.material_override as StandardMaterial3D
    material.albedo_texture = texture
    sprite.texture = texture
