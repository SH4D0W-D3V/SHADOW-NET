extends Node

#----Easy Access Functions----
#Format clock cycles
func for_cc(value: float) -> String:
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
		
#Format Numbers For Lables
func for_num(value: float) -> String:
	if value < 1000:
		return str(round(int(value)))
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
		
#String to Number
const BASE_SUFFIXES = {"": 1.0, "k": 1e3, "m": 1e6, "b": 1e9, "t": 1e12}
func str_to_num(input: String) -> float:
	var regex = RegEx.new()
	regex.compile("([0-9.]+)\\s*([a-zA-Z]*)")
	var result = regex.search(input.strip_edges())
	if not result: 
		return 0.0
	var num = result.get_string(1).to_float()
	var suffix = result.get_string(2).to_lower()
	if suffix == "": 
		return num
	if BASE_SUFFIXES.has(suffix):
		return num * BASE_SUFFIXES[suffix]
	if suffix.length() == 2:
		if suffix.unicode_at(0) >= 97 and suffix.unicode_at(1) >= 97:
			return num * get_double_letter_multiplier(suffix)
	return num
func get_double_letter_multiplier(suffix: String) -> float:
	var c1 = suffix.unicode_at(0) - 97
	var c2 = suffix.unicode_at(1) - 97
	var exponent = 15 + ((c1 * 26) + c2) * 3
	return pow(10, exponent)
