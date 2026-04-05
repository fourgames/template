@icon("uid://cdmyxwtwjrli8")
extends Node


enum GameState { MAIN_MENU, PAUSED, GAMEOVER}

var current_state := GameState.MAIN_MENU
var is_input_enabled := true
