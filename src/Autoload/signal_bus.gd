extends Node

@warning_ignore_start("unused_signal")

# lodge
signal lodge_upgraded(new_tier: int)
signal upgrade_failed(reason: String)

@warning_ignore_restore("unused_signal")