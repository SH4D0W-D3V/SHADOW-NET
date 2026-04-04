extends Control

var byte: int

func _ready():
	$Blog/AutoCont/Upgrade.hide()
	$Blog/AutoCont/Auto.show()
	if Global.Auto_type == true:
		$Blog/AutoCont/Upgrade.show()
		$Blog/AutoCont/Auto.hide()
	Cpu_btn_setup()
	Update_all_txt()
	
func _process(_delta: float) -> void:
	$ResourcePanel/Dollars.text = "Dollars: " + Global.format_number(Global.Dollars)
	$ResourcePanel/Research.text = "Research: " + Global.format_number(Global.Research_points)
	if Global.Auto_type == true:
		$Blog/ProgressBar.value = Global.blog_bytes

func _on_save_pressed() -> void:
	Global.save_game()
	
func _on_type_pressed() -> void:
	Global.blog_bytes += 16
	Update_all_txt()

func _on_cpu_pressed() -> void:
	if Global.Cpu == false:
		if Global.Dollars >= 4000:
			Global.Cpu = true
	else :
		get_tree().change_scene_to_file("res://Scenes/cpu.tscn")
	
func _on_auto_pressed() -> void:
	if Global.Dollars >=120:
		Global.Auto_type = true
		$Blog/AutoCont/Upgrade.show()
		$Blog/AutoCont/Auto.hide()
		Update_all_txt()
		Global.Dollars -= 120
		
func _on_upgrade_pressed() -> void:
	if Global.Dollars >= 480 * pow(2, Global.Auto_type_level - 1):
		Global.Dollars -= 480 * pow(2, Global.Auto_type_level - 1)
		Global.Auto_type_level += 1
		Update_all_txt()
		Cpu_btn_setup()
			
func Cpu_btn_setup():
	if Global.Auto_type_level >= 4:
		$Navigation/HBox/cpu.show()
		if Global.Cpu == true:
			$Navigation/HBox/cpu.text = "CPU"
		else:
			$Navigation/HBox/cpu.text = "Unlock: $4k"
	else:
		$Navigation/HBox/cpu.hide()

func _on_buy_ads_pressed() -> void:
	if Global.Dollars >= 800 * pow(2, Global.blog_level):
		Global.Dollars -= 800 * pow(2, Global.blog_level)
		Global.blog_level += 1
		Update_all_txt()

func _on_upgrade_2_pressed() -> void:
	if Global.blog_type < 4:
		if Global.Dollars >= Global.blog_purchase[Global.blog_type]:
			Global.Dollars -= Global.blog_purchase[Global.blog_type]
			Global.blog_type += 1
			Update_all_txt()
				
func Update_all_txt():
	$Blog/AutoCont/Upgrade.text = "Upgrade - " + Global.format_number(480 * pow(2, Global.Auto_type_level - 1))
	$Blog/AutoCont/Upgrade.text = "Upgrade - " + Global.format_number(480 * pow(2, Global.Auto_type_level - 1))
	$"Blog/Blog Lv/Buy Ads".text = "Buy - " + Global.format_number(800 * pow(2, Global.blog_level))
	$Blog/ProgressBar.max_value = Global.blog_dat[Global.blog_type]*2
	$Blog/ProgressBar.value = Global.blog_bytes
	$Blog/ProgressBar.max_value = Global.blog_dat[Global.blog_type]*2
	$"Blog/Blog Lv/Buy Ads".text = "Buy - " + Global.format_number(800 * pow(2, Global.blog_level))
	$Blog/AutoCont/Upgrade.text = "Upgrade - " + Global.format_number(480 * pow(2, Global.Auto_type_level - 1))
	if Global.blog_type < 4:
		$Blog/Upg_blog/upgrade2.text = "Upgrade - " + Global.format_number(Global.blog_purchase[Global.blog_type])
	else:
		$Blog/Upg_blog/upgrade2.text = "You are making the best content!"
	$"Blog/Blog Lv/Label".text = "Show ADs in Blog: lv-" + str(Global.blog_level)
	$Blog/AutoCont/Label.text = "Auto: lv-" + str(Global.Auto_type_level)

func _on_research_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Research.tscn")
