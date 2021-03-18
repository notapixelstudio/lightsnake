extends Node2D

func _on_Head_cell_completed(cell, energy_state):
	var cell_index = 0
	
	match energy_state:
		'low': cell_index = 2
		'normal': cell_index = 1
		'high': cell_index = 3
	
	$TileMap.set_cellv(cell, cell_index)
	
