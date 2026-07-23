extends Node2D
class_name ItemDrop

const ITEM_DROP_SCENE: PackedScene = preload("res://Scenes/item_drop.tscn")
const MIN_MOVE_SPEED: float = 50.0
const PICKUP_THRESHOLD: float = 5.0

@export var item_drops: Dictionary[StringName, Texture2D] = {
	&"wood": null,
	&"stone": null
}

# Item configuration
var item: StringName
var amount: int = 1
var pickup_distance: float = 100.0
var move_speed: float = 200.0

var collected: bool = false

@onready var sprite: Sprite2D = %sprite

var player: CharacterBody2D

static func setup(item_name: StringName, global_pos: Vector2, item_count: int = 1, distance: float = 100.0, speed: float = 200.0) -> ItemDrop:
	var drop: ItemDrop = ITEM_DROP_SCENE.instantiate()

	drop.item = item_name

	var random_offset: Vector2 = Vector2(randf_range(-20.0, 20.0), randf_range(-20.0, 20.0))
	drop.global_position = global_pos + random_offset

	drop.amount = item_count
	drop.pickup_distance = distance
	drop.move_speed = speed

	return drop


func _ready() -> void:
	sprite.texture = item_drops.get(item)


func _physics_process(delta: float) -> void:
	if not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player") as CharacterBody2D

	if player == null:
		return

	var distance: float = global_position.distance_to(player.global_position)

	if distance > pickup_distance:
		return

	var distance_ratio: float = 1.0 - (distance / pickup_distance)
	var current_speed: float = lerp(MIN_MOVE_SPEED, move_speed, distance_ratio)

	global_position = global_position.move_toward(
		player.global_position,
		current_speed * delta
	)

	print("dist:", distance)
	print("thereshold:", PICKUP_THRESHOLD)

	if distance <= PICKUP_THRESHOLD and not collected:
		print("emitted")
		pickup()


# Adds the item to the inventory and removes the drop.
func pickup() -> void:
	SignalBus.item_add_to_inv.emit(item, amount)
	collected = true
	call_deferred("queue_free")
