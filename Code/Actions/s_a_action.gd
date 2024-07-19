class_name SAAction extends Node2D

var SAOwner:SACharacterBody2D = null

func _ready():
	SAOwner = get_parent()
