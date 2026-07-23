extends  Node2D

signal lodge_upgraded(new_tier: int)
signal upgrade_failed(reason: String)

var tier: int = 0
var max_tier: int = 2

var upgrade_costs := [
	{},
	{"wood": 10, "stone": 5},
	{"wood": 20, "stone": 10},
]
var resources := {
	"wood": 0,
	"stone": 0,
}

func _process(delta: float) -> void:
	$resources.text = str("resources: ", resources)

	if tier >= max_tier:
		$UpgradeButton.disabled = true
		$cost.text = "MAXED LVL"
	else:
		$UpgradeButton.disabled = false
		$cost.text = str("cost: ", upgrade_costs[tier + 1])

func add_resource(resource_name, amount):
	resources[resource_name] += amount

func can_upgrade() -> bool:
	var cost = upgrade_costs[tier + 1]
	for resources_name in cost:
		if resources.get(resources_name,0) < cost[resources_name]:
			return false
	return true

func try_upgrade() -> bool:
	if tier >= max_tier:
		print("max level already")
		return false
	if not can_upgrade():
		print("not enough resources")
		return false

	var cost = upgrade_costs[tier + 1]
	for resources_name in cost:
		resources[resources_name] -= cost[resources_name]

	tier += 1
	return true

func _on_button_pressed() -> void:
	if can_upgrade():
		print("you can upgrade")
		try_upgrade()
	else:
		print("cant")

func _on_button_2_pressed() -> void:
	add_resource("wood",1)

func _on_button_3_pressed() -> void:
	add_resource("stone",1)
