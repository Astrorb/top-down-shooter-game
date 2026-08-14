extends Area2D

class_name WeaponPickup

#资源挂载上去，武器资源输入
@export var weapon_data: WeaponData
#武器精灵
@onready var weapon_sprite: Sprite2D = $WeaponSprite
#价格标签
@onready var price_label: Label = %PriceLabel
#购买标签
@onready var buy_label: Label = $BuyLabel
#是否交互
@onready var pickup: AudioStreamPlayer = $Pickup
var can_interact: bool


#初始化设置武器
func _ready() -> void:
	set_weapon()

func set_weapon() -> void:
	#从资源类中赋予精灵贴图
	weapon_sprite.texture = weapon_data.gun_sprite
	#赋予颜色
	weapon_sprite.modulate = weapon_data.gun_color
	#购买价格
	price_label.text = str(weapon_data.buy_price)

#_input() 是 引擎自动回调的内置函数。玩家产生任何输入动作 引擎就会自动调用一次 _input()。只有发生输入事件才执行
func _input(event: InputEvent) -> void:
	if can_interact and event.is_action_pressed("interact"):
		if GameManager.coins >= weapon_data.buy_price:
			pickup.play()
			GameManager.remove_coins(weapon_data.buy_price)
			#给player中 setup_weapon函数传参
			GameManager.player.setup_weapon(weapon_data)

#进入区域时显示购买标签
func _on_body_entered(body: Node2D) -> void:
	buy_label.show()
	can_interact = true

#离开区域时隐藏购买标签
func _on_body_exited(body: Node2D) -> void:
	buy_label.hide()
	can_interact = false
