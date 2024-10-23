@tool
extends EditorProperty

signal new_format_set(prop_name, new_test: String)
var object
var property_line = LineEdit.new()
var refresh_button = null
var format_holder = null
var regex = null

func _init() -> void:
	add_child(property_line)
	add_focusable(property_line)
	property_line.editable = false

	regex = RegEx.new()
	regex.compile("{(?<prop_name>[^}]+)}")

func _ready() -> void:
	assert(is_instance_valid(format_holder))
	assert(is_instance_valid(refresh_button))
	format_holder.text_submitted.connect(_new_format)
	format_holder.focus_exited.connect(func (): _new_format(format_holder.text))
	object = get_edited_object()
	refresh_button.button_up.connect(func (): _new_format(format_holder.text))

func _update_property() -> void:
	var new_value = object[get_edited_property()]
	if (property_line.text == new_value):
		return
	property_line.text = new_value

func _new_format(new_text: String):
	var edited_prop = get_edited_property()
	new_format_set.emit(edited_prop, new_text)

	var dict = {}
	for result in regex.search_all(new_text):
		var temp_name = result.get_string("prop_name")
		dict[temp_name] = object.get(temp_name)
	
	var formatted = new_text.format(dict)
	if(object[edited_prop] != formatted):
		object[edited_prop] = formatted
		emit_changed(edited_prop, formatted)
	
