extends CharacterBody2D

const SPEED = 300.0

func _ready() -> void:
	#signalbus.player_died.connect(_on_player_died)
	pass

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	if direction:
		velocity = direction * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)

	move_and_slide()
