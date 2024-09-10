extends GPUParticles2D

var age: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emitting = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	one_shot = true
	age += delta
	if age > lifetime:
		queue_free()
