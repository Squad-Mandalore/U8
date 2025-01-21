extends Control

var box_width := 200
var box_height := 100
var diagonal_offset := 20
var box_color := Color(0.1, 0.1, 0.1, 1)
var text_color := Color(1, 1, 1, 1)

func _ready():
    queue_redraw()

func _draw():
    # Define points for a diagonal box
    var points = [
        Vector2(0, 0),                     # Top-left
        Vector2(box_width, 0),            # Top-right
        Vector2(box_width - diagonal_offset, box_height),  # Bottom-right (diagonal offset)
        Vector2(0, box_height)            # Bottom-left
    ]

    # Draw the box
    draw_polygon(points, [Utils.RED])

    # Add text to the box
    # var text := "Diagonal Box"
    # var font := load("res://path_to_your_font.tres")  # Replace with your actual font path
    # draw_string(font, Vector2(10, box_height / 2), text, text_color)

