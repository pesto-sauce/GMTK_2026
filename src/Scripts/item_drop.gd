extends Node2D
class_name ItemDrop


const ITEM_DROP_SCENE: PackedScene = preload("res://Scenes/item_drop.tscn")
const MIN_MOVE_SPEED: float = 50.0
const PICKUP_THRESHOLD: float = 5.0

@export var item_drops: Dictionary[GameManager.Item, Texture2D] = {
	GameManager.Item.WOOD: null,
	GameManager.Item.STONE: null
}


# Item configuration
var item: GameManager.Item
var amount: int = 1
var pickup_distance: float = 100.0
var move_speed: float = 200.0
var random_offset: float = 20.0

var collected: bool = false


@onready var sprite: Sprite2D = %sprite

var player: CharacterBody2D


static func setup(item_name: GameManager.Item, global_pos: Vector2, item_count: int = 1, distance: float = 100.0, speed: float = 200.0, offset: float = 20.0) -> ItemDrop:
	var drop: ItemDrop = ITEM_DROP_SCENE.instantiate()

	drop.item = item_name
	drop.amount = item_count
	drop.pickup_distance = distance
	drop.move_speed = speed
	drop.random_offset = offset

	var random_position_offset: Vector2 = Vector2(
		randf_range(-offset, offset),
		randf_range(-offset, offset)
	)

	drop.global_position = global_pos + random_position_offset

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

	if distance <= PICKUP_THRESHOLD and not collected:
		pickup()


# Adds the item to the inventory and removes the drop.
func pickup() -> void:
	if collected:
		return

	collected = true

	SignalBus.item_add_to_inv.emit(item, amount)
	call_deferred("queue_free")
