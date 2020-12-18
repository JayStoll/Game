extends Node


class Stats:
	var health : int
	var damage : int

	func SetHealth(setHealth : int) -> void:
		health = setHealth

	func GetHealth() -> int:
		return health

	func SetDamage(setDamage : int) -> void:
		damage = setDamage

	func GetDamage() -> int:
		return damage

	func IsDead() -> bool:
		return GetHealth() <= 0

	func TakeDamage(damageAmount : int) -> void:
		health -= damageAmount
