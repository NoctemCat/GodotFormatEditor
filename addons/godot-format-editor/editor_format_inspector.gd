@tool
extends EditorInspectorPlugin

var PropertyEditor = preload("res://addons/godot-format-editor/editor_format_property.gd")
const MetadataName := "_PropertyFormatterFormats"

var _current_formats = {}

func _can_handle(object: Object) -> bool:
	return true

func _parse_begin(object: Object) -> void:
	_current_formats = object.get_meta(MetadataName, {})

func _parse_property(object: Object, type: Variant.Type, name: String, hint_type: PropertyHint, hint_string: String, usage_flags: int, wide: bool) -> bool:
	if type == TYPE_STRING && name.ends_with("_fo"):
		var vbox := VBoxContainer.new()
		var hbox := HBoxContainer.new()
		
		var ihbox := HBoxContainer.new()
		var label := Label.new()
		label.text = "%s format" % name
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		ihbox.add_child(label)
		
		var button := Button.new()
		button.text = "🔄"
		ihbox.add_child(button)
		
		ihbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hbox.add_child(ihbox)
		
		var lineEdit := LineEdit.new()
		lineEdit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		lineEdit.text = _current_formats.get(name, "")
		hbox.add_child(lineEdit)
		
		var margin := MarginContainer.new()
		margin.set("theme_override_constants/margin_left", 4)
		margin.set("theme_override_constants/margin_top", 4)
		margin.set("theme_override_constants/margin_right", 4)
		margin.add_child(hbox)
		vbox.add_child(margin)
		add_custom_control(vbox)
		
		var prop_editor = PropertyEditor.new()
		prop_editor.format_holder = lineEdit
		prop_editor.new_format_set.connect(_on_property_format_set)
		prop_editor.refresh_button = button
		
		add_property_editor(name, prop_editor)
		return true
	return false

func _parse_end(object: Object) -> void:
	object.set_meta(MetadataName, _current_formats)

func _on_property_format_set(prop_name:String, new_text: String):
	_current_formats[prop_name] = new_text
