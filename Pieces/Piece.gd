extends Node2D

export (String) var piece

var matched
var is_counted
var is_column_bomb = false
var is_row_bomb = false
var is_adjacent_bomb = false
var is_color_bomb = false
var selected = false
var target_position = Vector2(0,0)
var default_modulate = Color(1,1,1,1)
var highlight = Color(1,0.8,0,1)
var grid = Vector2.ZERO

var default_z = z_index
const max_z = 4095

var dying = false

func _ready():
	default_modulate = modulate
	target_position = position

func _physics_process(_delta):
	if dying:
		queue_free()
	if selected:
		if z_index == default_z:
			z_index = max_z
			target_position = position
		global_position = constrain(Vector2(get_global_mouse_position().x, get_global_mouse_position().y))
		if modulate != highlight:
			modulate = highlight
	else:
		if z_index != default_z:
			z_index = default_z
			position = target_position		
		if modulate != default_modulate:
			modulate = default_modulate
		

func move(change):
	target_position = change
	position = target_position

func dim():
	pass

func make_column_bomb():
	is_column_bomb = true

func make_row_bomb():
	is_row_bomb = true

func make_adjacent_bomb():
	is_adjacent_bomb = true

func make_color_bomb():
	is_color_bomb = true
	piece = "Color"

func die():
	dying = true
	Global.update_goals(piece)


func constrain(xy):
	var Grid = get_node_or_null("/root/Game/Grid")
	if Grid == null:
		return xy
	else:
		var temp = xy
		var tptg = Grid.pixel_to_grid(temp.x,temp.y)
		tptg.x = clamp(tptg.x,0,Grid.width-1)
		tptg.y = clamp(tptg.y,0,Grid.height-1)
		var gtp = Grid.grid_to_pixel(grid.x, grid.y)
		if tptg.x == grid.x:
			#extend y axis by 1 each direction
			temp.x = gtp.x
			var max_y = Grid.grid_to_pixel(grid.x, clamp(grid.y-1,0,grid.y))
			var min_y = Grid.grid_to_pixel(grid.x, clamp(grid.y+1,grid.y,Grid.height-1))
			temp.y = clamp(temp.y,min_y.y,max_y.y)
		elif tptg.x == grid.x and tptg.y == grid.y:
			pass
		else:
			#extend x axis by 1 each direction
			temp.y = gtp.y
			var min_x = Grid.grid_to_pixel(clamp(grid.x-1,0,grid.x), grid.y)
			var max_x = Grid.grid_to_pixel(clamp(grid.x+1,grid.x,Grid.width-1), grid.y)
			temp.x = clamp(temp.x,min_x.x,max_x.x)
		return temp
