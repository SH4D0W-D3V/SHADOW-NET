extends Node

#----Base_Data----
#Resources
var Dollars = 0
var reset_mode = false
var save_timer: Timer
#blog
var blog_bytes: int = 0
var Auto_type: bool = 0
var blog_level: int = 0
var Auto_type_level: int = 0
var blog_type: int = 0
const blog_dat = [100, 10000, 10000000, 1000000000, 10000000000, 100000000000 ]
const blog_cost = [100, 160000, 160000000, 160000000000, 16000000000000]
const  blog_purchase = [600000, 4000000000, 2000000000000, 1000000000000000]
#CPU
var Cpu: bool = false
var Selected
var level = 0
var Cpu_states: Array = [false, false]
var ClockCycles = 128 * pow(2, level)
var Cpu_Dollar = 0
var Cpu_Research_lv:int = 0
#Research
var Research: bool = false
var Research_points:float = 0
var purchased_ids: Array = []

#----SetUp On Play----
func _ready() -> void:
	load_game()
	setup_auto_save_timer()
#----Save and load data----
func save_game(): 
	if reset_mode:
		clear_save()
		return
	var save_data = {
		#Resources
		"Dollars": Dollars,
		#Blog
		"blog_bytes": blog_bytes,
		"Auto_type": Auto_type,
		"blog_level": blog_level,
		"Auto_type_level": Auto_type_level,
		"blog_type": blog_type,
		#Cpu
		"Cpu": Cpu,
		"Selected": Selected,
		"level": level,
		"Cpu_states": Cpu_states,
		"Cpu_Dollar": Cpu_Dollar,
		"Cpu_Research_lv": Cpu_Research_lv,
		#Research
		"Research": Research,
		"Research_points": Research_points,
		"purchased_ids": purchased_ids,
	}
	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close()

func load_game():
	if not FileAccess.file_exists("user://savegame.json"):
		return 
	var file = FileAccess.open("user://savegame.json", FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	if data == null:
		return 
	#resources
	Dollars     = data["Dollars"]
	#blog
	blog_bytes = data["blog_bytes"]
	Auto_type = data["Auto_type"]
	blog_level = data["blog_level"]
	Auto_type_level = data["Auto_type_level"]
	blog_type = data["blog_type"]
	#Cpu
	Cpu = data["Cpu"]
	Selected    = data["Selected"]
	level       = data["level"]
	Cpu_states  = data["Cpu_states"]
	ClockCycles = 128 * pow(2, level)
	Cpu_Dollar = data["Cpu_Dollar"]
	Cpu_Research_lv = data["Cpu_Research_lv"]
	#Research
	Research = data["Research"]
	Research_points = data["Research_points"]
	purchased_ids = data["purchased_ids"]

func clear_save():
	if FileAccess.file_exists("user://savegame.json"):
		DirAccess.remove_absolute("user://savegame.json")
		
func setup_auto_save_timer():
	save_timer = Timer.new()
	add_child(save_timer)
	save_timer.wait_time = 60.0
	save_timer.one_shot = false
	save_timer.autostart = true
	save_timer.timeout.connect(_on_save_timer_timeout)
	save_timer.start()

func _on_save_timer_timeout():
	save_game()
	
#----Live Updates----
func _process(delta: float) -> void:
	if Cpu_states[0] == true:
		Dollars += ((ClockCycles /Selected)* 2 *pow(2, 0)*pow(2, Cpu_Dollar)) * delta
	if Auto_type == true:
		blog_bytes += int(2 * pow(sqrt(2), Auto_type_level - 1) * (blog_level + 1))
	if blog_bytes >= blog_dat[blog_type]*2 :
		Dollars += blog_cost[blog_type] * (blog_level + 1)
		blog_bytes -= blog_dat[blog_type]*2
	if Cpu_states[1] == true:
		Research_points += 0.000001* (ClockCycles /Selected) *pow(2, Cpu_Research_lv/5)* delta
			
#----Easy Access Functions----
#Format Numbers For Lables
func format_number(value: float) -> String:
	if value < 1000:
		return str(round(value))
	var standard_suffixes = ["", "k", "M", "B", "T"]
	var exp_1000 = floor(log(value) / log(1000))
	if exp_1000 < standard_suffixes.size():
		var unit = standard_suffixes[exp_1000]
		var scaled_val = value / pow(1000, exp_1000)
		return "%.2f%s" % [scaled_val, unit]
	else:
		var aa_index = int(exp_1000) - 5
		var alphabet = "abcdefghijklmnopqrstuvwxyz"
		var first_letter = alphabet[floor(aa_index / 26)]
		var second_letter = alphabet[aa_index % 26]
		var unit = str(first_letter) + str(second_letter)
		var scaled_val = value / pow(1000, exp_1000)
		return "%.2f%s" % [scaled_val, unit]

#Format clock cycles
func format_clock_speed(value: float) -> String:
	if value < 1000:
		return "%.1f Hz" % value
	var std_suffixes = ["Hz", "kHz", "MHz", "GHz", "THz", "PHz", "EHz", "ZHz", "YHz"]
	var exp_1000 = floor(log(value) / log(1000))
	if exp_1000 < std_suffixes.size():
		var unit = std_suffixes[exp_1000]
		var scaled_val = value / pow(1000, exp_1000)
		return "%.2f %s" % [scaled_val, unit]
	else:
		var aa_index = int(exp_1000) - std_suffixes.size()
		var alphabet = "abcdefghijklmnopqrstuvwxyz"
		var first = alphabet[floor(aa_index / 26)]
		var second = alphabet[aa_index % 26]
		var unit = str(first) + str(second) + "Hz"
		var scaled_val = value / pow(1000, exp_1000)
		return "%.2f %s" % [scaled_val, unit]


			
