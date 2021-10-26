class_name Zombie
extends PlatformerBody2D


onready var plr: Node2D = get_tree().get_nodes_in_group("player")[0]
onready var pivot: Node2D = $Pivot


func _physics_process(_delta: float) -> void:
	var dir_to_plr := global_position.direction_to(plr.position)
	var hdir_to_plr := sign(dir_to_plr.x)
	set_move_direction(hdir_to_plr)
	pivot.scale.x = hdir_to_plr
