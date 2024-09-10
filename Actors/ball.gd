extends CharacterBody2D

## Initial/current speed of the ball
@export var speed: float = 3.0
@export var max_speed: float = 10.0
@export var score_label: RichTextLabel
@export var start_text: RichTextLabel
@export var paddle_shape: CollisionShape2D
@export var shrink_factor: Vector2 = Vector2(2,2)

@onready var ball_shape = $CollisionShape2D
@onready var ball_sprite = $Sprite2D
@onready var main = $/root
var particlesScenePL = preload("res://Particles.tscn")
var forward: Vector2 = Vector2(1,1).normalized()
var paddle_width: float = 170#paddle_shape.shape.get_rect.size.x
var current_score:int = 0
var is_running: bool = false
var game_over = false
var num_bricks: int = 30
var default_ball_size: int = 30

func _ready() -> void:
	ball_shape.shape.size = Vector2(default_ball_size, default_ball_size)
	ball_sprite.scale = Vector2(default_ball_size, default_ball_size)

func _physics_process(delta: float) -> void:
	if (not is_running):
		if (Input.is_action_just_pressed("canvas Click")):
			if (game_over):
				get_tree().reload_current_scene()
			is_running = true
			start_text.visible = false
			visible = true
		return
	if num_bricks <= 0:
		start_text.visible = true
		start_text.set_text("Success!")
		is_running = false
	var collision: KinematicCollision2D = move_and_collide(forward * speed)
	if (collision):
		forward = forward.bounce(collision.get_normal())
		speed = clamp(speed + 0.2, .1, max_speed)
		
		if (collision.get_collider().is_in_group("Bricks")):
			num_bricks -= 1
			ball_shape.shape.size -= shrink_factor
			ball_sprite.scale -= shrink_factor
			current_score +=1
			var temp_text = "Score: " + str(current_score)
			score_label.set_text(temp_text)
			var particles = particlesScenePL.instantiate()
			particles.position = collision.get_collider().position
			main.add_child(particles)
			collision.get_collider().queue_free()
		
		if (collision.get_collider().is_in_group("Paddle")):
			var paddle_x = collision.get_collider().position.x - 85
			var pos_on_paddle = (position.x - paddle_x)/paddle_width
			var bounce_angle = lerp(-PI + 0.2 , 0.2, pos_on_paddle)
			forward = Vector2.from_angle(bounce_angle)
		
		if (collision.get_collider().is_in_group("GameOver")):
			game_over = true
			is_running = false
			start_text.visible = true
			start_text.set_text("Game Over")
		
		if (collision.get_collider().is_in_group("Powerup")):
			shrink_factor = Vector2(-2,-2)
