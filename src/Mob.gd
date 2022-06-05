extends RigidBody2D

onready var anim_sprite := $AnimatedSprite
onready var collision_shape := $CollisionShape2D


func _ready():
	anim_sprite.playing = true
	
	var mob_types = anim_sprite.frames.get_animation_names()
	anim_sprite.animation = mob_types[randi() % mob_types.size()]


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
