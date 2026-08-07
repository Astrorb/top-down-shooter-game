extends Node2D
class_name Weapon

@onready var weapon_sprite: Sprite2D = $WeaponSprite
@onready var fire_pos: Marker2D = $FirePos
@onready var fire_sound: AudioStreamPlayer = $FireSound
@onready var anim_player: AnimationPlayer = $AnimationPlayer

#武器资源引用
var equipped_weapon: WeaponData
#子弹间隔发射时间
var delay_btw_shots: float

#渲染帧回调 每一帧间隔时间长短不一
#用途：画面渲染、UI、动画、输入检测、粒子特效这类视觉内容
func _process(delta: float) -> void:
	#计时开始减少
	delay_btw_shots -= delta
	if delay_btw_shots <= 0:
		#如果没有装备武器 if equipped_weapon == null: 退出函数
		if not equipped_weapon:
			return
		if Input.is_action_just_pressed("shoot"):
			shoot_bullet()
			#重置子弹间隔发射时间
			delay_btw_shots = equipped_weapon.delay_btw_shots

#射击子弹
func shoot_bullet() -> void:
	#实例化子弹场景
	var bullet: SingleBullet = equipped_weapon.bullet_scene.instantiate()
	#将fire_pos全局位置赋予实例子弹的全局位置
	bullet.global_position = fire_pos.global_position
	#伤害赋予
	bullet.damage = equipped_weapon.damage
	#从鼠标点位置获得子弹的移动方向归一化
	bullet.move_direction = (get_global_mouse_position() - global_position).normalized()
	#播放声音
	fire_sound.play()
	#播放枪花
	anim_player.play("Muzzle")
	#在根节点上添加子弹
	get_tree().root.add_child(bullet)

#player类中Setup()方法中调用，间接由pickup类中_input()方法调用
func init_weapon(weapon_data: WeaponData) ->void:
	#资源引用通过外部调用传入参数赋值
	equipped_weapon = weapon_data
	#资源引用通过外部调用传入参数赋值武器贴图
	weapon_sprite.texture = weapon_data.gun_sprite
	#资源引用通过外部调用传入参数赋值颜色
	weapon_sprite.self_modulate = weapon_data.gun_color
	#资源引用通过外部调用传入参数赋值发射间隔时间
	delay_btw_shots = weapon_data.delay_btw_shots
	#发射子弹的位置
	fire_pos.position = weapon_data.fire_pos

#旋转武器，完成当鼠标旋转超过头顶时
func rotate_weapon(value: bool) -> void:
	if value:
		weapon_sprite.flip_v = true
		fire_pos.position.y = 19.5
	else:
		weapon_sprite.flip_v = false
		fire_pos.position.y = -8.7
