extends Node2D
class_name Weapon

@onready var weapon_sprite: Sprite2D = $WeaponSprite
@onready var fire_pos: Marker2D = $FirePos

var equipped_weapon: WeaponData
var delay_btw_shots: float

func init_weapon(weapon_data: WeaponData) ->void:
	equipped_weapon = weapon_data
	weapon_sprite.texture = weapon_data.gun_sprite
	weapon_sprite.modulate = weapon_data.gun_color
	delay_btw_shots = weapon_data.delay_btw_shots
	
func rotate_weapon(value: bool) -> void:
	if value:
		weapon_sprite.flip_v = true
		fire_pos.position.y = 19.5
	else:
		weapon_sprite.flip_v = false
		fire_pos.position.y = -8.7
