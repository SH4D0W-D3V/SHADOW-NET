extends Control

# Define your items here
var shop_items = [
	{
		"name": "Speed Boots",
		"unlock_at": 1,
		"cost": 5,
		"id": "speed_up"
	},
	{
		"name": "Golden Sword",
		"unlock_at": 500,
		"cost": 1000,
		"id": "power_up"
	}
]

func _ready() -> void:
	refresh_shop()

func refresh_shop():
	for child in $Research/Scroll/VBox.get_children():
		child.queue_free()
	for item in shop_items:
		var is_unlocked = Global.Research_points >= item["unlock_at"]
		var already_bought = item["id"] in Global.purchased_ids
		if is_unlocked and not already_bought:
			create_button(item)

func create_button(data):
	var btn = Button.new()
	btn.text = data["name"] + " (Cost: " + str(data["cost"]) + ")"
	btn.pressed.connect(_on_button_pressed.bind(data["id"], data["cost"]))
	
	$Research/Scroll/VBox.add_child(btn)

func _on_button_pressed(item_id: String, cost: int):
	if Global.Research_points >= cost:
		Global.Research_points -= cost
		Global.purchased_ids.append(item_id)
		Global.save_game()
		run_item_logic(item_id)
		refresh_shop()
	else:
		print("Insufficient Research Points!")

func run_item_logic(id):
	match id:
		"speed_up":
			print("Player is now faster!")
		"power_up":
			print("Player is now stronger!")

func _on_back_pressed() -> void:
	Global.save_game()
	get_tree().change_scene_to_file("res://Scenes/home_screen.tscn")
