extends Sprite2D

var max_speed := 600.0
var velocity := Vector2(0, 0)


func _process(delta: float) -> void:
	var direction := Vector2(0, 0)
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")

	# If we don't do this and the player moves diagonally, they will move 40%
	# faster than normal.
	if direction.length() > 1.0:
		direction = direction.normalized()

	velocity = direction * max_speed
	position += velocity * delta

	if direction.length() > 0.0:
		rotation = velocity.angle()
