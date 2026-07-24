extends StaticBody2D
class_name Interactable

func _on_detection_box_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		SignalBus.context_update.emit(self , false)

func _on_detection_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		SignalBus.context_update.emit(self , true)


func interact() -> void:
	print("ineteracted")
	test_drop()

func test_drop() -> void:
	var item = ItemDrop.setup(GameManager.Item.WOOD, global_position, 50, 500)

	var holder = get_tree().root

	holder.add_child(item)

	call_deferred("queue_free")
