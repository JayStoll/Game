extends Node


# this class will handle the creation of the enemy characters

class EnemyStats:
	var id : int = 0

	var _data = EnemyData
	var stats = Stats.Stats.new()

	# take in an id which will be used within the data set
	func SetStatsFromDataID(setID : int) -> Stats:
		if setID != 0:
			id = setID-1
		_CreateEnemy()
		return stats

	func _CreateEnemy() -> void: 
		_HealthOverride()
		_DamageOverride()

	func _HealthOverride() -> void:
		if id >= 0:
			stats.SetHealth(int(_data.enemyData.Enemy_Data[id].health))
		else:
			print ("Error!")

	func _DamageOverride() -> void:
		if id >= 0:
			stats.SetDamage(int(_data.enemyData.Enemy_Data[id].damage))
		else:
			print("Error!")

	func GetHealth() -> int:
		return stats.GetHealth()

	func SetSprite(sprite : Sprite) -> void:
		var tex = load("res://Sprites/Enemies/" +_data.enemyData.Enemy_Data[id].name + ".png")
		sprite.texture = tex
	
	
