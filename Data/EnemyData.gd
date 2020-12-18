extends Node

var enemyData

func _ready():
	enemyData = OpenEnemyDataFile("res://Data/Enemy/EnemyTable.json")

func OpenEnemyDataFile(filePath : String) -> JSONParseResult:
	var file = File.new()
	file.open(filePath, File.READ)
	var fileJson = JSON.parse(file.get_as_text())
	file.close()
	return fileJson.result
