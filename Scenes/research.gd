extends Control

#---- Research items list ----
var shop_items = [
	{
		"name": "Add CPU Cores",
		"unlock_at": 1,
		"cost": 5,
		"id": "Add_Cores"
	},
	{
		"name": "Instant one time Money",
		"unlock_at": 40,
		"cost": 50,
		"id": "insta_money"
	}
]

#---- Ready ----
func _ready() -> void:
	refresh_shop()

#---- Other functions ----
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
	btn.custom_minimum_size = Vector2(0,100)
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
		"Add_Cores":
			Global.Cpu_cores += 1
		"insta_money":
			Global.Dollars += util.str_to_num("1T")

func _on_back_pressed() -> void:
	Global.save_game()
	get_tree().change_scene_to_file("res://Scenes/home_screen.tscn")
