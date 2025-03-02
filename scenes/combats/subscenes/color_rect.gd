extends ColorRect

var gradient_rect = ColorRect.new()
gradient_rect.set_anchors_and_margins_preset(Control.PRESET_FULL_RECT)

var gradient_texture = GradientTexture.new()
var gradient = Gradient.new()

gradient.add_point(0, Color(0, 0, 0, 0.8))
gradient.add_point(1, Color(0, 0, 0, 0))

gradient_texture.gradient = gradient
gradient_texture.width = 256

gradient_rect.texture = gradient_texture

var canvas_layer = CanvasLayer.new()
canvas_layer.add_child(gradient_rect)
get_tree().root.add_child(canvas_layer)
