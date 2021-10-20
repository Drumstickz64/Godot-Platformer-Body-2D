extends PlatformerBody2D


onready var plr: Node2D = get_tree().get_nodes_in_group("player")[0]
onready var pivot: Node2D = $Pivot


func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	
	var vec_to_plr := (plr.position - position)
	var dir_to_plr := sign(vec_to_plr.x)
	print(dir_to_plr)
	apply_acceleration(delta, dir_to_plr)
	
	pivot.scale.x = dir_to_plr
	velocity = move(delta, true)
