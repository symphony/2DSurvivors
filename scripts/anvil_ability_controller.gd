extends Node

const BASE_RANGE := 100
const COLLISION_OFFSET := -20 # allow ability to spawn slightly out of bounds
const BASE_ANVIL_COUNT := 1

var anvil_count = BASE_ANVIL_COUNT

@export var anvil_ability_scene: PackedScene


func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if !player:
		return

	var random_position = GameEvents.get_random_spawn_position(player.global_position, BASE_RANGE, COLLISION_OFFSET)
	var anvil_instance = anvil_ability_scene.instantiate()
	get_tree().get_first_node_in_group("foreground_layer").add_child(anvil_instance)
	anvil_instance.position = random_position


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "anvil_count":
		anvil_count = BASE_ANVIL_COUNT + current_upgrades["anvil_count"]["quantity"]
