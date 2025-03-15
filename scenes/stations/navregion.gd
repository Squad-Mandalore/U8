extends NavigationRegion2D


func _ready() -> void:
    self.bake_navigation_polygon()

func random_point_in_polygon() -> Vector2:
    var polygon = navigation_polygon.get_vertices()
    # Determine the bounding box of the polygon.
    var min_x = polygon[0].x
    var max_x = polygon[0].x
    var min_y = polygon[0].y
    var max_y = polygon[0].y

    for point in polygon:
        min_x = min(min_x, point.x)
        max_x = max(max_x, point.x)
        min_y = min(min_y, point.y)
        max_y = max(max_y, point.y)

    # Loop until a valid point is found.
    while true:
        var random_point = Vector2(randf_range(min_x, max_x), randf_range(min_y, max_y))
        if Geometry2D.is_point_in_polygon(random_point, polygon):
            return random_point

    return Vector2.ZERO  # This line is never reached.
