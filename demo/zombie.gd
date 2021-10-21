class_name Zombie
extends PlatformerBody2D


onready var plr: Node2D = get_tree().get_nodes_in_group("player")[0]
onready var pivot: Node2D = $Pivot


func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	
	var dir_to_plr := global_position.direction_to(plr.position)
	var hdir_to_plr := sign(dir_to_plr.x)
	apply_acceleration(delta, hdir_to_plr)
	
	pivot.scale.x = hdir_to_plr
	velocity = move(delta, true)
