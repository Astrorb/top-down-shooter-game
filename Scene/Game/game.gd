extends Node2D
@onready var player: CharacterBody2D = $Player
@onready var crosshair: Sprite2D = $Crosshair
@onready var camera_2d: Camera2D = $Camera2D
@onready var wave_label: Label = %WaveLabel
@onready var enemy_count_label: Label = %EnemyCountLabel
@onready var weapon: Node2D = $Weapon
@onready var enemy_spawner: EnemySpawner = $EnemySpawner
@onready var wave_timer: Timer = $WaveTimer
@onready var coins_label: Label = $CanvasLayer/GameUI/Coins/CoinsLabel
@onready var lost_label: Label = $CanvasLayer/LostLabel


func _ready() -> void:
	GameManager.on_player_died.connect(_on_player_died)
	wave_timer.start()
	#隐藏鼠标光标
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	#给全局脚本player 赋值引用
	GameManager.player = player
	
func _process(delta: float) -> void:
	#将鼠标位置赋值给准星位置
	crosshair.global_position = get_global_mouse_position()
	#将摄像机位置挂载到玩家位置
	camera_2d.global_position = player.global_position
	wave_label.text = "New Wave In\n%s" % int(wave_timer.time_left)
	coins_label.text = str(GameManager.coins)
	enemy_count_label.text = "Enemy: %s" % str(enemy_spawner.enemy_remaining)

func _on_player_died() -> void:
	lost_label.show()

func _on_enemy_spawner_on_wave_completed() -> void:
	weapon.show()
	wave_label.show()
	enemy_count_label.hide()
	wave_timer.start()

func _on_wave_timer_timeout() -> void:
	weapon.hide()
	wave_label.hide()
	enemy_count_label.show()
	enemy_spawner.start_enemy_timer()
	
