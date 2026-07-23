extends Node2D


var tier: int = 0
var max_tier: int = 2

var upgrade_costs := [
	{},
	{GameManager.Item.WOOD: 10, GameManager.Item.STONE: 5},
	{GameManager.Item.WOOD: 20, GameManager.Item.STONE: 10},
]

func _process(delta: float) -> void:
	$resources.text = str("resources: ", GameManager.player_inventory)

	if tier >= max_tier:
		$UpgradeButton.disabled = true
		$cost.text = "MAXED LVL"
	else:
		$UpgradeButton.disabled = false
		$cost.text = str("cost: ", upgrade_costs[tier + 1])


func can_upgrade() -> bool:
	var cost = upgrade_costs[tier + 1]
	for resource in cost:
		if GameManager.inv_has_item(resource, cost[resource]):
			return true
	return false

func try_upgrade() -> bool:
	if tier >= max_tier:
		SignalBus.upgrade_failed.emit("max level already")
		return false
	if not can_upgrade():
		SignalBus.upgrade_failed.emit("not enough resources")
		return false

	var cost = upgrade_costs[tier + 1]
	for resource in cost:
		GameManager.inv_remove_item(resource, cost[resource])
	
	tier += 1
	SignalBus.lodge_upgraded(tier)
	
	return true

func _on_button_pressed() -> void:
	try_upgrade()

func _on_button_2_pressed() -> void:
	GameManager.inv_add_item(GameManager.Item.WOOD, 1)

func _on_button_3_pressed() -> void:
	GameManager.inv_add_item(GameManager.Item.STONE, 1)
