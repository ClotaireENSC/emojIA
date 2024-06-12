extends Node2D

var screenshots_folder = "res://assets/screenshots/"
var images_folder = "res://assets/emojis"
var image_files = []
@onready var node_2d = $"."
var viewport_size = Vector2(1000, 1000)

func _ready():
	get_files_from_folder(images_folder)
	
	get_viewport().set_size(viewport_size)
	
	for l in range(50):
		await generate_image(l)

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
	var screenshot_path = screenshots_folder + "screenshot_%s.png" % k
	var screenshot = get_viewport().get_texture().get_image()
	screenshot.save_png(screenshot_path)
	print("Screenshot saved to: " + screenshot_path)
	
	emojis.queue_free()
