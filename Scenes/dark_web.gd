extends Control

var level: int = 1

func get_current_chance() -> float:
	return 0.9 * pow(0.9, level - 1)

func _ready():
	reset_site_buttons()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/home_screen.tscn")

func _on_yes_pressed() -> void:
	if Global.ShadowToken >= 1:
		Global.ShadowToken -= 1
		$"Main menu".hide()

func rand(site: int) -> void:
	set_buttons_disabled(true)
	var success_chance = get_current_chance()
	if randf() <= success_chance:
		level += 1
		var next_chance = get_current_chance()
		$Gamba/Status.text = "Level: %d\nChance: %d%%" % [level, int(next_chance * 100)]
		$"Gamba/Site 1".text = "Successful browsing" if site == 1 else "-"
		$"Gamba/Site 2".text = "Successful browsing" if site == 2 else "-"
		await get_tree().create_timer(1.5).timeout
		reset_site_buttons()
	else:
		$"Gamba/Site 1".text = "Hacked!"
		$"Gamba/Site 2".text = "Hacked!"
		Global.Dollars = 0
		Global.save_game()
		
		await get_tree().create_timer(1.5).timeout
		get_tree().change_scene_to_file("res://Scenes/home_screen.tscn")

func reset_site_buttons():
	$"Gamba/Site 1".text = "Load Site 1"
	$"Gamba/Site 2".text = "Load Site 2"
	set_buttons_disabled(false)

func set_buttons_disabled(is_disabled: bool):
	$"Gamba/Site 1".disabled = is_disabled
	$"Gamba/Site 2".disabled = is_disabled

func _on_site_1_pressed() -> void:
	rand(1)

func _on_site_2_pressed() -> void:
	rand(2)
