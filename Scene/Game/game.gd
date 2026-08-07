extends Node2D
@onready var player: CharacterBody2D = $Player
@onready var crosshair: Sprite2D = $Crosshair
@onready var camera_2d: Camera2D = $Camera2D

func _ready() -> void:
	#隐藏鼠标光标
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	#给全局脚本player 赋值引用
	GameManager.player = player
	
func _process(delta: float) -> void:
	#将鼠标位置赋值给准星位置
	crosshair.global_position = get_global_mouse_position()
	#将摄像机位置挂载到玩家位置
	camera_2d.global_position = player.global_position
