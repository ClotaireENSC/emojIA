extends Node2D

@onready var node_2d = $"."
var screenshots_folder = "res://assets/screenshots/"
var images_folder = "res://assets/emojis"
var scenes_folder = "res://assets/pop_scenes/"
var image_files = []
var viewport_size = Vector2(1000, 1000)
var screenshot_path : String
var score : float

@export var id : int

func _ready():
	get_files_from_folder(images_folder)
	
	get_viewport().set_size(viewport_size)
	
	await generate_image(id)
	
	get_score()

func get_files_from_folder(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				if not file_name.ends_with(".import"):
					image_files.append(path + "/" + file_name)
			file_name = dir.get_next()
		dir.list_dir_end()

func get_random_image():
	var random_index = randi() % image_files.size()
	return load(image_files[random_index])

func randomize_sprite(sprite):
	sprite.position.x = randi() % 1000 - 500
	sprite.position.y = randi() % 1000 - 500
	sprite.scale = Vector2(1,1) * randf() * 2 
	sprite.rotation = randf() * 360

func generate_image(k):
	var emojis = Node2D.new()
	node_2d.add_child(emojis)
	
	for i in range(500):
		var img = get_random_image()
		var tmp_sprite = Sprite2D.new()
		randomize_sprite(tmp_sprite)
		tmp_sprite.texture = img
		emojis.add_child(tmp_sprite)
	
	await get_tree().process_frame
	await get_tree().process_frame
	screenshot_path = screenshots_folder + "screenshot_%s.png" % k
	var screenshot = get_viewport().get_texture().get_image()
	screenshot.save_png(screenshot_path)
	
	#save_scene("pop_scene_%s.tscn" % k)

func get_score():
	var image = Image.new()
	image.load(screenshot_path)
	
	var tmp_score = 0
	
	var photo = Image.new()
	photo.load("res://assets/photos/moi2.jpg")
	photo.resize(1000,1000)
	
	for x in range(image.get_width()):
		for y in range(image.get_height()):
			var color = image.get_pixel(x, y)
			var color2 = photo.get_pixel(x, y)
			tmp_score +=  pixel_distance(color, color2)
	
	score = tmp_score

func pixel_distance(pixel1: Color, pixel2: Color) -> float:
	var r_diff = pixel2.r - pixel1.r
	var g_diff = pixel2.g - pixel1.g
	var b_diff = pixel2.b - pixel1.b

	var distance = sqrt(r_diff * r_diff + g_diff * g_diff + b_diff * b_diff)

	return distance

#func save_scene(filename):
	#var save = PackedScene.new()
	#for c in self.get_children():
		#c.set_owner(self)
		#for a in c.get_children():
			#a.set_owner(self)
	#save.pack(self);
#
	#ResourceSaver.save(save, "res://assets/pop_scenes/"  + filename);
