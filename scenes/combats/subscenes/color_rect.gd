extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

var gradient_rect = ColorRect.new()
gradient_rect.set_anchors_and_margins_preset(Control.PRESET_FULL_RECT)

var gradient_texture = GradientTexture.new()
var gradient = Gradient.new()

# Farben für den Verlauf definieren
gradient.add_point(0, Color(0, 0, 0, 0.8))  # Oben fast schwarz
gradient.add_point(1, Color(0, 0, 0, 0))    # Unten transparent

gradient_texture.gradient = gradient
gradient_texture.width = 256  # Auflösung des Verlaufs

gradient_rect.texture = gradient_texture

# Dem CanvasLayer hinzufügen, um es über das Spiel zu legen
var canvas_layer = CanvasLayer.new()
canvas_layer.add_child(gradient_rect)
get_tree().root.add_child(canvas_layer)
