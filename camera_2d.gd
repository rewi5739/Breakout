extends Camera2D

@export var decay : float = .8
@export var noise : FastNoiseLite
@export var max_offset : Vector2 = Vector2(100, 75)
var trauma : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	noise.seed = randi()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if trauma:
		trauma = max(trauma - decay * delta, 0)
