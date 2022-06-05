extends Area2D

signal hit


onready var anim_sprite := $AnimatedSprite
onready var collision_shape := $CollisionShape2D

export var speed := 400  # How fast the player will move (pixels/sec)
var screen_size: Vector2


func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()


func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		anim_sprite.play()
	else:
		anim_sprite.stop()
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0


func start(pos: Vector2):
	position = pos
	show()
	collision_shape.disabled = false


func _on_Player_body_entered(body: Node) -> void:
	hide()
	emit_signal("hit")
	
	# Must be deferred as we can't change physics properties on a physics callback.
	collision_shape.set_deferred("disabled", true)
