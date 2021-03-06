extends Node


onready var player := $Player
onready var mob_timer := $MobTimer
onready var score_timer := $ScoreTimer
onready var start_timer := $StartTimer
onready var start_position := $StartPosition
onready var mob_spawn_location := $MobPath/MobSpwanLocation
onready var hud := $HUD
onready var bgm := $BGM
onready var death_sound := $DeathSound


export var mob_scene: PackedScene


var score: int


func _ready():
	randomize()


func new_game():
	score = 0
	player.start(start_position.position)
	start_timer.start()
	hud.update_score(score)
	hud.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	bgm.play()


func _on_Player_hit() -> void:
	# gameover
	score_timer.stop()
	mob_timer.stop()
	hud.show_game_over()
	bgm.stop()
	death_sound.play()


func _on_ScoreTimer_timeout() -> void:
	score += 1
	hud.update_score(score)


func _on_StartTimer_timeout() -> void:
	mob_timer.start()
	score_timer.start()


func _on_MobTimer_timeout() -> void:
	var mob: Mob = mob_scene.instance()
	
	# PathFollower2D 위치 랜덤하게 이동
	mob_spawn_location.unit_offset = randf()
	
	# path direction에 수직 + 각도 살짝
	var direction = mob_spawn_location.rotation + (PI / 2) + rand_range(-PI / 4, PI / 4)
	
	mob.position = mob_spawn_location.position
	mob.rotation = direction
	
	var velocity = Vector2(rand_range(150.0, 250.0), 0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)
