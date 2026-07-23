extends CharacterBody2D

const SPEED = 300.0

var current_context = null # Used by the context button to call current_context.interact()

func _ready() -> void:
	add_to_group("player")

	SignalBus.context_update.connect(_on_context_update)
	#signalbus.player_died.connect(_on_player_died)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("contextual") and current_context:
		if current_context.has_method("interact"):
			current_context.interact()
		else:
			push_warning("Current context does not have an interact() method.")


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	if direction:
		velocity = direction * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)

	move_and_slide()

func _on_context_update(interactable: Area2D, entered: bool) -> void:
	if entered:
		current_context = interactable
	else:
		if current_context == interactable:
			current_context = null