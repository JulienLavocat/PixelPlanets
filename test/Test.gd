extends Node2D

@onready var planet: Planet = $Planet

func _ready():
	planet.set_pixels(512)
	planet.randomize_colors()
	planet.set_seed(randi())

func _process(delta):
	pass
