extends TextureRect


func _get_drag_data(at_position: Vector2) -> Variant:
    var data = {}

    data["drag_texture"] = self.texture

    var drag_texture = TextureRect.new()
    drag_texture.expand_mode = 1
    drag_texture.texture = self.texture
    drag_texture.size = Vector2(62, 62)

    set_drag_preview(drag_texture)

    return data

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
    print("I am not called from the item frame")
    return true

func _drop_data(at_position: Vector2, data: Variant) -> void:
    print("thus i also am not called")
    self.texture = data["drag_texture"]

