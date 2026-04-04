extends Control

var Avail_cc: int

func _ready():
	update_checkboxes_from_array()
	update_all_txt()
	for checkbox in get_tree().get_nodes_in_group("Checkbox"):
		checkbox.toggled.connect(_update_label)
		_update_label(false) # set initial value

func _update_label(_toggled_value) -> void:
	Global.Selected = get_checked_count()
	if Global.Selected != 0:
		Avail_cc = int(Global.ClockCycles / Global.Selected)
	else:
		Avail_cc = 0
	upd_a_cc()
		

func get_checked_count() -> int:
	var count = 0
	Global.Cpu_states = []
	var checkboxes = get_tree().get_nodes_in_group("Checkbox")
	for button in checkboxes:
		var cb = button as CheckBox
		Global.Cpu_states.append(cb.button_pressed)
		if button.button_pressed:
			count += 1
	return count

	
func _process(_delta: float) -> void:
	$Resources/Dollars.text = "Dollars: " + Global.format_number(Global.Dollars)

#update Cpu
func _on_upgrade_pressed() -> void:
	if Global.Dollars > 30720 * pow(4, Global.level):
		Global.Dollars -= 30720 * pow(4, Global.level)
		Global.level += 1
		Global.ClockCycles = 128 * pow(2, Global.level)
		upd_a_cc()
		get_checked_count()
		_update_label(false)
		
		
func upd_a_cc():
	if $ResourcesCard/card1/CheckBox.button_pressed == true:
		$ResourcesCard/card1/ClockCycles.text = Global.format_clock_speed(Avail_cc)
	else:
		$ResourcesCard/card1/ClockCycles.text = "0 Hz"
	if $ResourcesCard/card2/CheckBox2.button_pressed == true:
		$ResourcesCard/card2/ClockCycles.text = Global.format_clock_speed(Avail_cc)
	else:
		$ResourcesCard/card2/ClockCycles.text = "0 Hz"
	update_all_txt()

func update_checkboxes_from_array():
	var checkboxes = get_tree().get_nodes_in_group("Checkbox")
	for i in range(checkboxes.size()):
		if i < Global.Cpu_states.size():
			var cb = checkboxes[i] as CheckBox
			cb.button_pressed = Global.Cpu_states[i]

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/home_screen.tscn")

func _on_upgrade_1_pressed() -> void:
	if Global.Dollars >= 26000 * pow(10, Global.Cpu_Dollar):
		Global.Dollars -= 26000 * pow(10, Global.Cpu_Dollar)
		Global.Cpu_Dollar += 1
		update_all_txt()

func update_all_txt():
	$Container/ClockCycles.text = "Clock Cycles: " + Global.format_clock_speed(Global.ClockCycles)
	$ResourcesCard/card1/upgrade1.text = "Upgrade - " + Global.format_number(26000 * pow(10, Global.Cpu_Dollar-1))
	$Container/upgrade.text = "Upgrade - " + Global.format_number(30720 * pow(4, Global.level))
	$ResourcesCard/card2/upgrade2.text = "Upgrade - " + Global.format_number(1700000 * pow(10, Global.Cpu_Research_lv))
	
func _on_upgrade_2_pressed() -> void:
	if Global.Dollars >= 1700000 * pow(10, Global.Cpu_Research_lv):
		Global.Dollars -= 1700000 * pow(10, Global.Cpu_Research_lv)
		Global.Cpu_Research_lv += 1
		update_all_txt()
	
	
	
	
	
	
