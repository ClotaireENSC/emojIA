extends Node2D

const GENERATED_IMAGE = preload("res://scenes/generated_image.tscn")
var nb_img = 200
var nb_best = nb_img/10
var mutation_rate = 0.2
var mutation_range = 1

func _ready():
	print("\n=== Génération des scenes ...")
	for l in range(nb_img):
		var image_sc = GENERATED_IMAGE.instantiate()
		image_sc.id = l
		add_child(image_sc)
		image_sc.generate_image(image_sc.id)
		await get_tree().process_frame
		await get_tree().process_frame
	
	for k in range(100):
		print(get_children().size())
		print(get_children()[0].get_children().size())
		
		print("\n=== Enregistrement des images ...")
		
		for s in get_children():
			await s.photo(s.id)
		
		print("\n=== Calcul des scores ...")
		
		for s in get_children():
			s.get_score()
		
		print("\n=== Sélection des meilleures images ...")
		
		var n = nb_best
		var top_scenes = await get_top_n_scenes(n)
		print("best score : " + str(top_scenes[0].score))
		
		print("\n=== Duplication + Mutations ...")
		
		for s in top_scenes:
			for a in range((nb_img/nb_best)-1):
				var tmp = s.duplicate()
				tmp.score = s.score
				add_child(tmp)
				tmp.mutate(mutation_rate, mutation_range)
		
		print("\n=== Indexation ...")
		
		var new_id = 0
		for s in get_children():
			s.id = new_id
			new_id += 1

func get_top_n_scenes(n):
	var scenes = get_children()
	var scenes_data = []

	for s in scenes:
		var score = s.score
		var screenshot_path = s.screenshot_path
		var data = {
			"scene" : s,
			"score": score,
			"screenshot_path": screenshot_path
		}
		scenes_data.append(data)

	scenes_data = bubble_sort(scenes_data)
	
	var top_n_scenes = []
	var other_scenes = []

	for i in range(scenes_data.size()):
		var scene_data = scenes_data[i]
		if i < n:
			top_n_scenes.append(scene_data["scene"])
		else:
			other_scenes.append(scene_data["scene"])

	for s in other_scenes:
		s.free()

	return top_n_scenes

func bubble_sort(array):
	var length = array.size()
	for i in range(length - 1):
		for j in range(length - i - 1):
			if array[j]["score"] > array[j + 1]["score"]:
				var temp = array[j]
				array[j] = array[j + 1]
				array[j + 1] = temp
	return array
