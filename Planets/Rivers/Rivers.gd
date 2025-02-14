extends "res://Planets/Planet.gd"

func set_pixels(amount):
	$Land.material.set_shader_parameter("pixels", amount)
	$Cloud.material.set_shader_parameter("pixels", amount)
	$Land.size = Vector2(amount, amount)
	$Cloud.size = Vector2(amount, amount)

func set_light(pos):
	$Cloud.material.set_shader_parameter("light_origin", pos)
	$Land.material.set_shader_parameter("light_origin", pos)

func set_seed(sd):
	var converted_seed = sd%1000/100.0
	$Cloud.material.set_shader_parameter("seed", converted_seed)
	$Cloud.material.set_shader_parameter("cloud_cover", randf_range(0.35, 0.6))
	$Land.material.set_shader_parameter("seed", converted_seed)

func set_rotates(r):
	$Cloud.material.set_shader_parameter("rotation", r)
	$Land.material.set_shader_parameter("rotation", r)

func update_time(t):
	$Cloud.material.set_shader_parameter("time", t * get_multiplier($Cloud.material) * 0.01)
	$Land.material.set_shader_parameter("time", t * get_multiplier($Land.material) * 0.02)

func set_custom_time(t):
	$Cloud.material.set_shader_parameter("time", t * get_multiplier($Cloud.material) * 0.5)
	$Land.material.set_shader_parameter("time", t * get_multiplier($Land.material))

func set_dither(d):
	$Land.material.set_shader_parameter("should_dither", d)

func get_dither():
	return $Land.material.get_shader_parameter("should_dither")

var color_vars1 = ["col1","col2","col3", "col4", "river_col", "river_col_dark"]
var color_vars2 = ["base_color", "outline_color", "shadow_base_color", "shadow_outline_color"]

func get_colors():
	return (_get_colors_from_vars($Land.material, color_vars1)
	+ _get_colors_from_vars($Cloud.material, color_vars2)
	)

func set_colors(colors):
	_set_colors_from_vars($Land.material, color_vars1, colors.slice(0, 6, 1))
	_set_colors_from_vars($Cloud.material, color_vars2, colors.slice(6, 10, 1))

func randomize_colors():
	var seed_colors = _generate_new_colorscheme(randi()%2+3, randf_range(0.7, 1.0), randf_range(0.45, 0.55))
	var land_colors: Array[Color] = []
	var river_colors: Array[Color] = []
	var cloud_colors: Array[Color] = []
	for i in 4:
		var new_col = seed_colors[0].darkened(i/4.0)
		land_colors.append(Color.from_hsv(new_col.h + (0.2 * (i/4.0)), new_col.s, new_col.v))
	
	for i in 2:
		var new_col = seed_colors[1].darkened(i/2.0)
		river_colors.append(Color.from_hsv(new_col.h + (0.2 * (i/2.0)), new_col.s, new_col.v))
	
	for i in 4:
		var new_col = seed_colors[2].lightened((1.0 - (i/4.0)) * 0.8)
		cloud_colors.append(Color.from_hsv(new_col.h + (0.2 * (i/4.0)), new_col.s, new_col.v))
	set_colors(land_colors + river_colors + cloud_colors)
