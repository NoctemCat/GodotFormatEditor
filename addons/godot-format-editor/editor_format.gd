@tool
extends EditorPlugin

var FormatEditor = preload("res://addons/godot-format-editor/editor_format_inspector.gd")
var plugin = null

func _enter_tree() -> void:
	plugin = FormatEditor.new()
	add_inspector_plugin(plugin)

func _exit_tree() -> void:
	remove_inspector_plugin(plugin)

func _get_plugin_name() -> String:
	return "FormatEditor"
