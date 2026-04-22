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

var shop_data = {
	"ShadowToken": {"text": "Shadown Token 1\nResearch - 10", "cost": 10, "currency": "research"},
	"research_kit": {"text": "", "cost": 10, "currency": "research"},
	"unlock_cpu": {"text": "Unlock CPU", "cost": 4000, "currency": "dollars"}
}
#---- Ready ----
func _ready() -> void:
	refresh_shop()
	create_shop()

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

func _on_shop_item_purchased(item_id: String):
	var item = shop_data[item_id]
	var cost = item["cost"]
	var type = item["currency"]
	var can_afford = false
	match type:
		"dollars":
			if Global.Dollars >= cost: can_afford = true
		"research":
			if Global.Research_points >= cost: can_afford = true
	if can_afford:
		match type:
			"dollars": Global.Dollars -= cost
			"research":
				Global.Research_points -= cost
				print("res")
		match item_id:
			"ShadowToken":
				Global.ShadowToken += 1
			"research_kit":
				print("hi")
			"unlock_cpu":
				Global.Cpu = true
	else:
		print("Insufficient " + type + "!")
		
func create_shop():
	for item_id in shop_data:
		var data = shop_data[item_id]
		var btn = Button.new()
		btn.text = data["text"] + " - $" + str(data["cost"])
		btn.custom_minimum_size = Vector2(0, 100)
		btn.pressed.connect(_on_shop_item_purchased.bind(item_id))
		$Purchase/Scroll/VBox.add_child(btn)
