extends Control

#---- Var ---- 


#---- Basic Process ----
func _ready():
	$Blog/AutoCont/Upgrade.visible = Global.Auto_type
	$Blog/AutoCont/Auto.visible = !Global.Auto_type
	$ResourcePanel/ShadowToken.text = "Shadow Tokens: " + util.for_num(Global.ShadowToken)
	Global.save_game()
	Nav_btn_setup()
	Update_all_txt()

func _process(_delta: float) -> void:
	$ResourcePanel/Dollars.text = "Dollars: " + util.for_num(Global.Dollars)
	$ResourcePanel/Research.text = "Research: " + util.for_num(Global.Research_points)
	if Global.Auto_type == true:
		$Blog/ProgressBar.value = Global.blog_bytes

func Update_all_txt():
	$Blog/AutoCont/Upgrade.text = "Upgrade - " + util.for_num(480 * pow(2, Global.Auto_type_level - 1))
	$Blog/AutoCont/Upgrade.text = "Upgrade - " + util.for_num(480 * pow(2, Global.Auto_type_level - 1))
	$"Blog/Blog Lv/Buy Ads".text = "Buy - " + util.for_num(800 * pow(2, Global.blog_level))
	$Blog/ProgressBar.max_value = Global.blog_dat[Global.blog_type]*2
	$Blog/ProgressBar.value = Global.blog_bytes
	$Blog/ProgressBar.max_value = Global.blog_dat[Global.blog_type]*2
	$"Blog/Blog Lv/Buy Ads".text = "Buy - " + util.for_num(800 * pow(2, Global.blog_level))
	$Blog/AutoCont/Upgrade.text = "Upgrade - " + util.for_num(480 * pow(2, Global.Auto_type_level - 1))
	if Global.blog_type < 4:
		$Blog/Upg_blog/upgrade2.text = "Upgrade - " + util.for_num(Global.blog_purchase[Global.blog_type])
	else:
		$Blog/Upg_blog/upgrade2.text = "You are making the best content!"
	$"Blog/Blog Lv/Label".text = "Show ADs in Blog: lv-" + str(Global.blog_level)
	$Blog/AutoCont/Label.text = "Auto: lv-" + str(Global.Auto_type_level)

#---- Top Bar----
func _on_save_pressed() -> void:
	Global.save_game()
	
#---- Resources Display ----
#//No script here yet//

#---- Blogging ----
#Manual typing
func _on_type_pressed() -> void:
	Global.blog_bytes += 16
	Update_all_txt()
	
#main Auto mode unlock button
func _on_auto_pressed() -> void: 
	if util.buy(120):
		Global.Auto_type = true
		$Blog/AutoCont/Upgrade.show()
		$Blog/AutoCont/Auto.hide()
		Update_all_txt()

# upgrade Automode
func _on_upgrade_pressed() -> void: 
	if util.buy(480 * pow(2, Global.Auto_type_level - 1)):
		Global.Auto_type_level += 1
		Update_all_txt()
		Nav_btn_setup()

#Upgrade ads
func _on_buy_ads_pressed() -> void:
	if util.buy(800 * pow(2, Global.blog_level)):
		Global.blog_level += 1
		Update_all_txt()

#upgrade blog content
func _on_upgrade_2_pressed() -> void:
	if Global.blog_type < 4:
		if util.buy(Global.blog_purchase[Global.blog_type]):
			Global.blog_type += 1
			Update_all_txt()

#---- Navigation Bar ----
func Nav_btn_setup():
	if Global.Auto_type_level >= 4:
		$Navigation/HBox/cpu.show()
		if Global.Cpu == true:
			$Navigation/HBox/cpu.text = "CPU"
		else:
			$Navigation/HBox/cpu.text = "Unlock: $4k"
	else:
		$Navigation/HBox/cpu.hide()
	if Global.Auto_type_level >= 6:
		$Navigation/HBox/Research.show()
		if Global.Research == true:
			$Navigation/HBox/Research.text = "Research"
		else:
			$Navigation/HBox/Research.text = "Unlock: $30k"
	else:
		$Navigation/HBox/Research.hide()

func _on_cpu_pressed() -> void:
	if Global.Cpu == false:
		if Global.Dollars >= 4000:
			Global.Cpu = true
	else :
		get_tree().change_scene_to_file("res://Scenes/cpu.tscn")

func _on_research_pressed() -> void:
	if Global.Research == false:
		if Global.Dollars >= 30000:
			Global.Research = true
	else :
		get_tree().change_scene_to_file("res://Scenes/Research.tscn")

func _on_dark_web_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/DarkWeb.tscn")
