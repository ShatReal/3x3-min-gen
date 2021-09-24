tool
extends EditorPlugin


var dock: Control


func _enter_tree() -> void:
	dock = preload("res://addons/3x3_min_gen/3x3_min_gen.tscn").instance()
	add_control_to_dock(DOCK_SLOT_RIGHT_UL, dock)
	dock.connect("saved_image", self, "_on_saved_image")


func _exit_tree() -> void:
	remove_control_from_docks(dock)
	dock.free()


func _on_saved_image() -> void:
	get_editor_interface().get_resource_filesystem().scan()
