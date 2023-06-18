extends Node2D

@onready var menu = $Menu
@onready var start_menu = $Menu/HBoxContainer/StartMenu
@onready var settings_menu = $Menu/HBoxContainer/SetingsMenu
@onready var game_menu = $Menu/HBoxContainer/GameMenu

@onready var game = preload("res://game/Game.tscn").instantiate()

func _ready():
	Global.game = game	
	start_menu.show()
	settings_menu.hide()
	game_menu.hide()

func _on_start_button_pressed():
	settings_menu.hide()
	game_menu.show()

func _on_settings_button_pressed():
	game_menu.hide()
	settings_menu.show()

func _on_quit_button_pressed():
	get_tree().quit()
	
func _on_game_menu_start_pressed():
	menu.hide()
	add_child(game)
