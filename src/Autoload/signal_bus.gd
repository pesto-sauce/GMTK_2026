extends Node

@warning_ignore_start("unused_signal")

signal item_add_to_inv(item: GameManager.Item, amount: int)
signal item_remove_from_inv(item: GameManager.Item, amount: int)


@warning_ignore_restore("unused_signal")