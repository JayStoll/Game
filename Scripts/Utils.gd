extends Node


func GetMainNode() -> Node:
	var rootNode : Node = get_tree().get_root()
	return rootNode.get_child(rootNode.get_child_count() - 1)