extends Camera2D

@export var decay : float = .8
@export var noise : FastNoiseLite
@export var max_offset : Vector2 = Vector2(100, 75)
@export var trauma_power : float = 2
var trauma : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	noise.seed = randi()

func add_trauma(amount) -> void:
	trauma = min(trauma + amount, 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()


func shake() -> void:
	var amount = pow(trauma, trauma_power)
	offset.x = max_offset.x * amount * randf_range(-1, 1)
	offset.y = max_offset.y * amount * randf_range(-1, 1)


func _on_ball_collision_shake(strength: float) -> void:
	print("called signal reciever")
	add_trauma(strength)
