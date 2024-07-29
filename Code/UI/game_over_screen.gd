class_name GameOverScreen extends Control

const DEAD = preload("res://Textures/AssetPack/Light/transform/transform9.png")
const STONE = preload("res://Textures/minerals/Icon16.png")

@onready var game_over_title:Label = %game_over_title
@onready var game_over_text:Label = %game_over_text
@onready var succes_sprite = %succes_sprite
@onready var dead_sprite = %dead_sprite

var dead_title := tr("gameover_dead_title")
var dead_text := tr("gameover_dead_texte")
var succes_title := tr("gameover_success_title")
var succes_text := tr("gameover_success_texte")

var result := ""

func _ready():
	SASignals.CharacterNoMoreLive.connect(_set_dead)
	SASignals.GameSucces.connect(_set_succes)

func _process(_delta):
	if visible and SAInput.ui_cancel:
		hide()
		SASignals.LoadWorld.emit("main_menu")

func _set_dead(_data):
	if _data == GameMode.character.data:
		result = "dead"
		_display_game_over(result)

func _set_succes():
	result = "succes"
	_display_game_over(result)

func _display_game_over(_result := ""):
	if _result == "dead":
		game_over_title.text = dead_title
		game_over_text.text = dead_text
		dead_sprite.show()
	elif _result == "succes":
		game_over_title.text = succes_title
		game_over_text.text = succes_text
		succes_sprite.show()
	if _result: 
		SASignals.FocusedOnUi.emit(true)
		show()
