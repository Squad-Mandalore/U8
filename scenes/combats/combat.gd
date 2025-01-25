extends Node3D

var enemy: Enemy:
    set(value):
        enemy = value
        update_enemy()
        %CombatHud.set_enemy(enemy)

# TODO: update floor
func update_floor(floor: Node3D):
    %Floor.queue_free()
    add_child(floor)

func update_enemy():
    %Enemy.material_override.albedo_texture = enemy.albedo_texture
    %Enemy.sprite_frames = enemy._sprite.sprite_frames
    %Enemy.animation = enemy.combat_animation
    %Enemy.play()
