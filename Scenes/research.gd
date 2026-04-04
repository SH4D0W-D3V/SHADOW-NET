extends Control

var shop_items = [
	{
		"name": "Speed Boots",
		"unlock_at": 1,  # The "Milestone" to show the button
		"cost": 5,      # The actual price to buy it
		"id": "speed_up"  # A unique tag to know what code to run
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


func refresh_shop ():
	for child in $Research/Scroll/VBox.get_children():
		child.queue_free()
	for item in shop_items:
		if Global.Research_points >= item["unlock_at"]:
			create_button(item)

func create_button(data):
	var btn = Button.new()
	btn.text = data["name"] + " (Cost: " + str(data["cost"]) + ")"
	btn.pressed.connect(_on_button_pressed.bind(data["id"], data["cost"]))
	$Research/Scroll/VBox.add_child(btn)

func _on_button_pressed(item_id: String, cost: int):
	if Global.Research_points >= cost:
		Global.Research_points -= cost
		run_item_logic(item_id)
	else:
		print(Global.Research_points)

func run_item_logic(id):
	match id:
		"speed_up":
			pass
		"power_up":
			pass

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/home_screen.tscn")
