extends Node2D
@onready var player: CharacterBody2D = $Player
@onready var crosshair: Sprite2D = $Crosshair
@onready var camera_2d: Camera2D = $Camera2D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
func _process(delta: float) -> void:
	crosshair.global_position = get_global_mouse_position()
	camera_2d.global_position = player.global_position
