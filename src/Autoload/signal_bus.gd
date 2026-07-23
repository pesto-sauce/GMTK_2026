extends Node

@warning_ignore_start("unused_signal")

# lodge
signal lodge_upgraded(new_tier: int)
signal upgrade_failed(reason: String)

# context btn
signal context_update(interactable: Area2D, entered: bool)

@warning_ignore_restore("unused_signal")