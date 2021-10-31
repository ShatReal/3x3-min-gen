tool
extends Control

signal saved_image


var _which_folder := "input"
var dialog: EditorFileDialog

func _ready() -> void:
	dialog = EditorFileDialog.new()
	dialog.rect_size = Vector2(800, 400)
	dialog.window_title = "Select a Path"
	add_child(dialog)
	dialog.connect("file_selected", self, "_on_file_selected")


func _on_gen_image_pressed() -> void:
	var texture := load($VBox/Input/LineEdit.text)
	var tiles: Image = texture.get_data()
	var tile_size := tiles.get_width() / 5
	var half_tile_size := tile_size / 2
	
	var output := Image.new()
	output.create(tile_size * 12, tile_size * 4, false, Image.FORMAT_RGBA8)
	
	var tile_blits := {
		Rect2(0, 0, half_tile_size, half_tile_size): [
			Vector2(0, 0),
			Vector2(0, tile_size * 3),
			Vector2(tile_size, 0),
			Vector2(tile_size, tile_size * 3),
			Vector2(tile_size * 8, 0),
		],
		Rect2(0, half_tile_size, half_tile_size, half_tile_size): [
			Vector2(0, tile_size * 2 + half_tile_size),
			Vector2(0, tile_size * 3 + half_tile_size),
			Vector2(tile_size, tile_size * 2 + half_tile_size),
			Vector2(tile_size, tile_size * 3 + half_tile_size),
			Vector2(tile_size * 8, tile_size * 3 + half_tile_size),
		],
		Rect2(half_tile_size, 0, half_tile_size, half_tile_size): [
			Vector2(half_tile_size, 0),
			Vector2(half_tile_size, tile_size * 3),
			Vector2(tile_size * 3 + half_tile_size, 0),
			Vector2(tile_size * 3 + half_tile_size, tile_size * 3),
			Vector2(tile_size * 11 + half_tile_size, 0),
		],
		Rect2(half_tile_size, half_tile_size, half_tile_size, half_tile_size): [
			Vector2(half_tile_size, tile_size * 2 + half_tile_size),
			Vector2(half_tile_size, tile_size * 3 + half_tile_size),
			Vector2(tile_size * 3 + half_tile_size, tile_size * 2 + half_tile_size),
			Vector2(tile_size * 3 + half_tile_size, tile_size * 3 + half_tile_size),
			Vector2(tile_size * 11 + half_tile_size, tile_size * 3 + half_tile_size),
		],
		Rect2(tile_size, 0, half_tile_size, half_tile_size): [
			Vector2(0, tile_size),
			Vector2(0, tile_size * 2),
			Vector2(tile_size, tile_size),
			Vector2(tile_size, tile_size * 2),
			Vector2(tile_size * 4, tile_size),
			Vector2(tile_size * 4, tile_size * 2),
			Vector2(tile_size * 8, tile_size),
			Vector2(tile_size * 8, tile_size * 3),
		],
		Rect2(tile_size, half_tile_size, half_tile_size, half_tile_size): [
			Vector2(0, half_tile_size),
			Vector2(0, tile_size + half_tile_size),
			Vector2(tile_size, half_tile_size),
			Vector2(tile_size, tile_size + half_tile_size),
			Vector2(tile_size * 4, tile_size + half_tile_size),
			Vector2(tile_size * 4, tile_size * 2 + half_tile_size),
			Vector2(tile_size * 8, half_tile_size),
			Vector2(tile_size * 8, tile_size + half_tile_size),
		],
		Rect2(tile_size + half_tile_size, 0, half_tile_size, half_tile_size): [
			Vector2(half_tile_size, tile_size),
			Vector2(half_tile_size, tile_size * 2),
			Vector2(tile_size * 3 + half_tile_size, tile_size),
			Vector2(tile_size * 3 + half_tile_size, tile_size * 2),
			Vector2(tile_size * 7 + half_tile_size, tile_size),
			Vector2(tile_size * 7 + half_tile_size, tile_size * 2),
			Vector2(tile_size * 11 + half_tile_size, tile_size * 2),
			Vector2(tile_size * 11 + half_tile_size, tile_size * 3),
		],
		Rect2(tile_size + half_tile_size, half_tile_size, half_tile_size, half_tile_size): [
			Vector2(half_tile_size, half_tile_size),
			Vector2(half_tile_size, tile_size + half_tile_size),
			Vector2(tile_size * 3 + half_tile_size, half_tile_size),
			Vector2(tile_size * 3 + half_tile_size, tile_size + half_tile_size),
			Vector2(tile_size * 7 + half_tile_size, tile_size + half_tile_size),
			Vector2(tile_size * 7 + half_tile_size, tile_size * 2 + half_tile_size),
			Vector2(tile_size * 11 + half_tile_size, half_tile_size),
			Vector2(tile_size * 11 + half_tile_size, tile_size * 2 + half_tile_size),
		],
		Rect2(tile_size * 2, 0, half_tile_size, half_tile_size): [
			Vector2(tile_size * 2, 0),
			Vector2(tile_size * 2, tile_size * 3),
			Vector2(tile_size * 3, 0),
			Vector2(tile_size * 3, tile_size * 3),
			Vector2(tile_size * 5, 0),
			Vector2(tile_size * 6, 0),
			Vector2(tile_size * 10, 0),
			Vector2(tile_size * 11, 0),
		],
		Rect2(tile_size * 2, half_tile_size, half_tile_size, half_tile_size): [
			Vector2(tile_size * 2, tile_size * 2 + half_tile_size),
			Vector2(tile_size * 2, tile_size * 3 + half_tile_size),
			Vector2(tile_size * 3, tile_size * 2 + half_tile_size),
			Vector2(tile_size * 3, tile_size * 3 + half_tile_size),
			Vector2(tile_size * 5, tile_size * 3 + half_tile_size),
			Vector2(tile_size * 6, tile_size * 3 + half_tile_size),
			Vector2(tile_size * 9, tile_size * 3 + half_tile_size),
			Vector2(tile_size * 11, tile_size * 3 + half_tile_size),
		],
		Rect2(tile_size * 2 + half_tile_size, 0, half_tile_size, half_tile_size): [
			Vector2(tile_size + half_tile_size, 0),
			Vector2(tile_size + half_tile_size, tile_size * 3),
			Vector2(tile_size * 2 + half_tile_size, 0),
			Vector2(tile_size * 2 + half_tile_size, tile_size * 3),
			Vector2(tile_size * 5 + half_tile_size, 0),
			Vector2(tile_size * 6 + half_tile_size, 0),
			Vector2(tile_size * 8 + half_tile_size, 0),
			Vector2(tile_size * 10 + half_tile_size, 0),
		],
		Rect2(tile_size * 2 + half_tile_size, half_tile_size, half_tile_size, half_tile_size): [
			Vector2(tile_size + half_tile_size, tile_size * 2 + half_tile_size),
			Vector2(tile_size + half_tile_size, tile_size * 3 + half_tile_size),
			Vector2(tile_size * 2 + half_tile_size, tile_size * 2 + half_tile_size),
			Vector2(tile_size * 2 + half_tile_size, tile_size * 3 + half_tile_size),
			Vector2(tile_size * 5 + half_tile_size, tile_size * 3 + half_tile_size),
			Vector2(tile_size * 6 + half_tile_size, tile_size * 3 + half_tile_size),
			Vector2(tile_size * 8 + half_tile_size, tile_size * 3 + half_tile_size),
			Vector2(tile_size * 9 + half_tile_size, tile_size * 3 + half_tile_size),
		],
		Rect2(tile_size * 3, 0, half_tile_size, half_tile_size): [
			Vector2(tile_size * 2, tile_size),
			Vector2(tile_size * 2, tile_size * 2),
			Vector2(tile_size * 3, tile_size),
			Vector2(tile_size * 3, tile_size * 2),
			Vector2(tile_size * 4, tile_size * 3),
			Vector2(tile_size * 5, tile_size),
			Vector2(tile_size * 5, tile_size * 3),
			Vector2(tile_size * 7, 0),
			Vector2(tile_size * 7, tile_size),
			Vector2(tile_size * 7, tile_size * 3),
			Vector2(tile_size * 8, tile_size * 2),
			Vector2(tile_size * 9, 0),
			Vector2(tile_size * 9, tile_size),
		],
		Rect2(tile_size * 3, half_tile_size, half_tile_size, half_tile_size): [
			Vector2(tile_size * 2, half_tile_size),
			Vector2(tile_size * 2, tile_size + half_tile_size),
			Vector2(tile_size * 3, half_tile_size),
			Vector2(tile_size * 3, tile_size + half_tile_size),
			Vector2(tile_size * 4, half_tile_size),
			Vector2(tile_size * 5, half_tile_size),
			Vector2(tile_size * 5, tile_size * 2 + half_tile_size),
			Vector2(tile_size * 7, half_tile_size),
			Vector2(tile_size * 7, tile_size * 2 + half_tile_size),
			Vector2(tile_size * 7, tile_size * 3 + half_tile_size),
			Vector2(tile_size * 8, tile_size * 2 + half_tile_size),
			Vector2(tile_size * 10, tile_size * 2 + half_tile_size),
			Vector2(tile_size * 10, tile_size * 3 + half_tile_size),
		],
		Rect2(tile_size * 3 + half_tile_size, 0, half_tile_size, half_tile_size): [
			Vector2(tile_size + half_tile_size, tile_size),
			Vector2(tile_size + half_tile_size, tile_size * 2),
			Vector2(tile_size * 2 + half_tile_size, tile_size),
			Vector2(tile_size * 2 + half_tile_size, tile_size * 2),
			Vector2(tile_size * 4 + half_tile_size, 0),
			Vector2(tile_size * 4 + half_tile_size, tile_size),
			Vector2(tile_size * 4 + half_tile_size, tile_size * 3),
			Vector2(tile_size * 6 + half_tile_size, tile_size),
			Vector2(tile_size * 6 + half_tile_size, tile_size * 3),
			Vector2(tile_size * 7 + half_tile_size, tile_size * 3),
			Vector2(tile_size * 9 + half_tile_size, 0),
			Vector2(tile_size * 10 + half_tile_size, tile_size * 2),
			Vector2(tile_size * 11 + half_tile_size, tile_size)
		],
		Rect2(tile_size * 3 + half_tile_size, half_tile_size, half_tile_size, half_tile_size): [
			Vector2(tile_size + half_tile_size, half_tile_size),
			Vector2(tile_size + half_tile_size, tile_size + half_tile_size),
			Vector2(tile_size * 2 + half_tile_size, half_tile_size),
			Vector2(tile_size * 2 + half_tile_size, tile_size + half_tile_size),
			Vector2(tile_size * 4 + half_tile_size, half_tile_size),
			Vector2(tile_size * 4 + half_tile_size, tile_size * 2 + half_tile_size),
			Vector2(tile_size * 4 + half_tile_size, tile_size * 3 + half_tile_size),
			Vector2(tile_size * 6 + half_tile_size, half_tile_size),
			Vector2(tile_size * 6 + half_tile_size, tile_size * 2 + half_tile_size),
			Vector2(tile_size * 7 + half_tile_size, half_tile_size),
			Vector2(tile_size * 9 + half_tile_size, tile_size + half_tile_size),
			Vector2(tile_size * 10 + half_tile_size, tile_size * 3 + half_tile_size),
			Vector2(tile_size * 11 + half_tile_size, tile_size + half_tile_size),
		],
		Rect2(tile_size * 4, 0, half_tile_size, half_tile_size): [
			Vector2(tile_size * 4, 0),
			Vector2(tile_size * 5, tile_size * 2),
			Vector2(tile_size * 6, tile_size),
			Vector2(tile_size * 6, tile_size * 2),
			Vector2(tile_size * 6, tile_size * 3),
			Vector2(tile_size * 7, tile_size * 2),
			Vector2(tile_size * 9, tile_size * 2),
			Vector2(tile_size * 9, tile_size * 3),
			Vector2(tile_size * 10, tile_size * 2),
			Vector2(tile_size * 10, tile_size * 3),
			Vector2(tile_size * 11, tile_size),
			Vector2(tile_size * 11, tile_size * 2),
			Vector2(tile_size * 11, tile_size * 3),
		],
		Rect2(tile_size * 4, half_tile_size, half_tile_size, half_tile_size): [
			Vector2(tile_size * 4, tile_size * 3 + half_tile_size),
			Vector2(tile_size * 5, tile_size + half_tile_size),
			Vector2(tile_size * 6, half_tile_size),
			Vector2(tile_size * 6, tile_size + half_tile_size),
			Vector2(tile_size * 6, tile_size * 2 + half_tile_size),
			Vector2(tile_size * 7, tile_size + half_tile_size),
			Vector2(tile_size * 9, half_tile_size),
			Vector2(tile_size * 9, tile_size + half_tile_size),
			Vector2(tile_size * 9, tile_size * 2 + half_tile_size),
			Vector2(tile_size * 10, half_tile_size),
			Vector2(tile_size * 11, half_tile_size),
			Vector2(tile_size * 11, tile_size + half_tile_size),
			Vector2(tile_size * 11, tile_size * 2 + half_tile_size),
		],
		Rect2(tile_size * 4 + half_tile_size, 0, half_tile_size, half_tile_size): [
			Vector2(tile_size * 4 + half_tile_size, tile_size * 2),
			Vector2(tile_size * 5 + half_tile_size, tile_size),
			Vector2(tile_size * 5 + half_tile_size, tile_size * 2),
			Vector2(tile_size * 5 + half_tile_size, tile_size * 3),
			Vector2(tile_size * 6 + half_tile_size, tile_size * 2),
			Vector2(tile_size * 7 + half_tile_size, 0),
			Vector2(tile_size * 8 + half_tile_size, tile_size),
			Vector2(tile_size * 8 + half_tile_size, tile_size * 2),
			Vector2(tile_size * 8 + half_tile_size, tile_size * 3),
			Vector2(tile_size * 9 + half_tile_size, tile_size),
			Vector2(tile_size * 9 + half_tile_size, tile_size * 2),
			Vector2(tile_size * 9 + half_tile_size, tile_size * 3),
			Vector2(tile_size * 10 + half_tile_size, tile_size * 3),
		],
		Rect2(tile_size * 4 + half_tile_size, half_tile_size, half_tile_size, half_tile_size): [
			Vector2(tile_size * 4 + half_tile_size, tile_size + half_tile_size),
			Vector2(tile_size * 5 + half_tile_size, half_tile_size),
			Vector2(tile_size * 5 + half_tile_size, tile_size + half_tile_size),
			Vector2(tile_size * 5 + half_tile_size, tile_size * 2 + half_tile_size),
			Vector2(tile_size * 6 + half_tile_size, tile_size + half_tile_size),
			Vector2(tile_size * 7 + half_tile_size, tile_size * 3 + half_tile_size),
			Vector2(tile_size * 8 + half_tile_size, half_tile_size),
			Vector2(tile_size * 8 + half_tile_size, tile_size + half_tile_size),
			Vector2(tile_size * 8 + half_tile_size, tile_size * 2 + half_tile_size),
			Vector2(tile_size * 9 + half_tile_size, half_tile_size),
			Vector2(tile_size * 9 + half_tile_size, tile_size * 2 + half_tile_size),
			Vector2(tile_size * 10 + half_tile_size, half_tile_size),
			Vector2(tile_size * 10 + half_tile_size, tile_size * 2 + half_tile_size),
		],
	}
	
	for key in tile_blits:
		for dest in tile_blits[key]:
			output.blit_rect(tiles, key, dest)
	
	output.save_png($VBox/OutputImage/LineEdit.text)
	emit_signal("saved_image")
	
	
func _on_gen_tile_set_pressed() -> void:
	var texture := load($VBox/OutputImage/LineEdit.text)
	var tile_size: int = texture.get_width() / 12
	var tile_set := TileSet.new()
	tile_set.create_tile(0)
	tile_set.tile_set_name(0, "output")
	tile_set.tile_set_texture(0, texture)
	tile_set.tile_set_region(0, Rect2(0, 0, tile_size * 12, tile_size * 4))
	tile_set.tile_set_tile_mode(0, TileSet.AUTO_TILE)
	tile_set.autotile_set_size(0, Vector2(tile_size, tile_size))
	tile_set.autotile_set_bitmask_mode(0, TileSet.BITMASK_3X3_MINIMAL)
	tile_set.autotile_set_bitmask(0, Vector2(0, 0),
		TileSet.BIND_CENTER + TileSet.BIND_BOTTOM)
	tile_set.autotile_set_bitmask(0, Vector2(0, 1),
		TileSet.BIND_TOP + TileSet.BIND_CENTER + TileSet.BIND_BOTTOM)
	tile_set.autotile_set_bitmask(0, Vector2(0, 2),
		TileSet.BIND_TOP + TileSet.BIND_CENTER)
	tile_set.autotile_set_bitmask(0, Vector2(0, 3),
		TileSet.BIND_CENTER)
	tile_set.autotile_set_bitmask(0, Vector2(1, 0),
		TileSet.BIND_CENTER + TileSet.BIND_BOTTOM + TileSet.BIND_RIGHT)
	tile_set.autotile_set_bitmask(0, Vector2(1, 1),
		TileSet.BIND_TOP + TileSet.BIND_CENTER + TileSet.BIND_BOTTOM + TileSet.BIND_RIGHT)
	tile_set.autotile_set_bitmask(0, Vector2(1, 2),
		TileSet.BIND_TOP + TileSet.BIND_CENTER + TileSet.BIND_RIGHT)
	tile_set.autotile_set_bitmask(0, Vector2(1, 3),
		TileSet.BIND_CENTER + TileSet.BIND_RIGHT)
	tile_set.autotile_set_bitmask(0, Vector2(2, 0),
		TileSet.BIND_LEFT + TileSet.BIND_CENTER + TileSet.BIND_BOTTOM + TileSet.BIND_RIGHT)
	tile_set.autotile_set_bitmask(0, Vector2(2, 1),
		TileSet.BIND_LEFT + TileSet.BIND_TOP + TileSet.BIND_CENTER + TileSet.BIND_BOTTOM + TileSet.BIND_RIGHT)
	tile_set.autotile_set_bitmask(0, Vector2(2, 2),
		TileSet.BIND_LEFT + TileSet.BIND_TOP + TileSet.BIND_CENTER + TileSet.BIND_RIGHT)
	tile_set.autotile_set_bitmask(0, Vector2(2, 3),
		TileSet.BIND_LEFT + TileSet.BIND_CENTER + TileSet.BIND_RIGHT)
	tile_set.autotile_set_bitmask(0, Vector2(3, 0),
		TileSet.BIND_LEFT + TileSet.BIND_CENTER + TileSet.BIND_BOTTOM)
	tile_set.autotile_set_bitmask(0, Vector2(3, 1),
		TileSet.BIND_TOP + TileSet.BIND_LEFT + TileSet.BIND_CENTER + TileSet.BIND_BOTTOM)
	tile_set.autotile_set_bitmask(0, Vector2(3, 2),
		TileSet.BIND_TOP + TileSet.BIND_LEFT + TileSet.BIND_CENTER)
	tile_set.autotile_set_bitmask(0, Vector2(3, 3),
		TileSet.BIND_LEFT + TileSet.BIND_CENTER)
	tile_set.autotile_set_bitmask(0, Vector2(4, 0),
		TileSet.BIND_TOPLEFT + TileSet.BIND_LEFT + TileSet.BIND_TOP + TileSet.BIND_CENTER + TileSet.BIND_BOTTOM + TileSet.BIND_RIGHT)
	tile_set.autotile_set_bitmask(0, Vector2(4, 1),
		TileSet.BIND_TOP + TileSet.BIND_CENTER + TileSet.BIND_BOTTOM + TileSet.BIND_RIGHT + TileSet.BIND_BOTTOMRIGHT)
	tile_set.autotile_set_bitmask(0, Vector2(4, 2),
		TileSet.BIND_TOP + TileSet.BIND_CENTER + TileSet.BIND_BOTTOM + TileSet.BIND_TOPRIGHT + TileSet.BIND_RIGHT)
	tile_set.autotile_set_bitmask(0, Vector2(4, 3),
		TileSet.BIND_LEFT + TileSet.BIND_BOTTOMLEFT + TileSet.BIND_TOP + TileSet.BIND_CENTER + TileSet.BIND_BOTTOM + TileSet.BIND_RIGHT)
	tile_set.autotile_set_bitmask(0, Vector2(5, 0),
		TileSet.BIND_LEFT + TileSet.BIND_CENTER + TileSet.BIND_BOTTOM + TileSet.BIND_RIGHT + TileSet.BIND_BOTTOMRIGHT)
	tile_set.autotile_set_bitmask(0, Vector2(5, 1),
		TileSet.BIND_LEFT + TileSet.BIND_BOTTOMLEFT + TileSet.BIND_TOP + TileSet.BIND_CENTER + TileSet.BIND_BOTTOM + TileSet.BIND_TOPRIGHT + TileSet.BIND_RIGHT + TileSet.BIND_BOTTOMRIGHT)
	tile_set.autotile_set_bitmask(0, Vector2(5, 2),
		TileSet.BIND_TOPLEFT + TileSet.BIND_LEFT + TileSet.BIND_TOP + TileSet.BIND_CENTER + TileSet.BIND_BOTTOM + TileSet.BIND_TOPRIGHT + TileSet.BIND_RIGHT + TileSet.BIND_BOTTOMRIGHT)
	tile_set.autotile_set_bitmask(0, Vector2(5, 3),
		TileSet.BIND_LEFT + TileSet.BIND_TOP + TileSet.BIND_CENTER + TileSet.BIND_TOPRIGHT + TileSet.BIND_RIGHT)
	tile_set.autotile_set_bitmask(0, Vector2(6, 0),
		TileSet.BIND_LEFT + TileSet.BIND_BOTTOMLEFT + TileSet.BIND_CENTER + + TileSet.BIND_BOTTOM + TileSet.BIND_RIGHT)
	tile_set.autotile_set_bitmask(0, Vector2(6, 1),
		TileSet.BIND_TOPLEFT + TileSet.BIND_LEFT + TileSet.BIND_BOTTOMLEFT + TileSet.BIND_TOP + TileSet.BIND_CENTER + TileSet.BIND_BOTTOM + TileSet.BIND_RIGHT + TileSet.BIND_BOTTOMRIGHT)
	tile_set.autotile_set_bitmask(0, Vector2(6, 2),
		TileSet.BIND_TOPLEFT + TileSet.BIND_LEFT + TileSet.BIND_BOTTOMLEFT + TileSet.BIND_TOP + TileSet.BIND_CENTER + TileSet.BIND_BOTTOM + TileSet.BIND_TOPRIGHT + TileSet.BIND_RIGHT)
	tile_set.autotile_set_bitmask(0, Vector2(6, 3),
		TileSet.BIND_TOPLEFT + TileSet.BIND_LEFT + TileSet.BIND_TOP + TileSet.BIND_CENTER + TileSet.BIND_RIGHT)
	tile_set.autotile_set_bitmask(0, Vector2(7, 0),
		TileSet.BIND_TOPRIGHT + TileSet.BIND_LEFT + TileSet.BIND_TOP + TileSet.BIND_CENTER + TileSet.BIND_BOTTOM + TileSet.BIND_RIGHT)
	tile_set.autotile_set_bitmask(0, Vector2(7, 1),
		TileSet.BIND_LEFT + TileSet.BIND_BOTTOMLEFT + TileSet.BIND_TOP + TileSet.BIND_CENTER + TileSet.BIND_BOTTOM)
	tile_set.autotile_set_bitmask(0, Vector2(7, 2),
		TileSet.BIND_TOPLEFT + TileSet.BIND_LEFT + TileSet.BIND_TOP + TileSet.BIND_CENTER + TileSet.BIND_BOTTOM)
	tile_set.autotile_set_bitmask(0, Vector2(7, 3),
		TileSet.BIND_LEFT + TileSet.BIND_TOP + TileSet.BIND_CENTER + TileSet.BIND_BOTTOM + TileSet.BIND_RIGHT + TileSet.BIND_BOTTOMRIGHT)
	tile_set.autotile_set_bitmask(0, Vector2(8, 0),
		TileSet.BIND_CENTER + TileSet.BIND_BOTTOM + TileSet.BIND_RIGHT + TileSet.BIND_BOTTOMRIGHT)
	tile_set.autotile_set_bitmask(0, Vector2(8, 1),
		TileSet.BIND_TOP + TileSet.BIND_CENTER + TileSet.BIND_BOTTOM + TileSet.BIND_TOPRIGHT + TileSet.BIND_RIGHT + TileSet.BIND_BOTTOMRIGHT)
	tile_set.autotile_set_bitmask(0, Vector2(8, 2),
		TileSet.BIND_LEFT + TileSet.BIND_TOP + TileSet.BIND_CENTER + TileSet.BIND_BOTTOM + TileSet.BIND_TOPRIGHT + TileSet.BIND_RIGHT + TileSet.BIND_BOTTOMRIGHT)
	tile_set.autotile_set_bitmask(0, Vector2(8, 3),
		TileSet.BIND_TOP + TileSet.BIND_CENTER + TileSet.BIND_TOPRIGHT + TileSet.BIND_RIGHT)
	tile_set.autotile_set_bitmask(0, Vector2(9, 0),
		TileSet.BIND_LEFT + TileSet.BIND_BOTTOMLEFT + TileSet.BIND_TOP + TileSet.BIND_CENTER + TileSet.BIND_BOTTOM + TileSet.BIND_RIGHT + TileSet.BIND_BOTTOMRIGHT)
	tile_set.autotile_set_bitmask(0, Vector2(9, 1),
		TileSet.BIND_LEFT + TileSet.BIND_BOTTOMLEFT + TileSet.BIND_TOP + TileSet.BIND_CENTER + TileSet.BIND_BOTTOM + TileSet.BIND_TOPRIGHT + TileSet.BIND_RIGHT)
	tile_set.autotile_set_bitmask(0, Vector2(9, 2),
		TileSet.BIND_TOPLEFT + TileSet.BIND_LEFT + TileSet.BIND_BOTTOMLEFT + TileSet.BIND_TOP + TileSet.BIND_CENTER + TileSet.BIND_BOTTOM + TileSet.BIND_TOPRIGHT + TileSet.BIND_RIGHT + TileSet.BIND_BOTTOMRIGHT)
	tile_set.autotile_set_bitmask(0, Vector2(9, 3),
		TileSet.BIND_TOPLEFT + TileSet.BIND_LEFT + TileSet.BIND_TOP + TileSet.BIND_CENTER + TileSet.BIND_TOPRIGHT + TileSet.BIND_RIGHT)
	tile_set.autotile_set_bitmask(0, Vector2(10, 0),
		TileSet.BIND_LEFT + TileSet.BIND_BOTTOMLEFT + TileSet.BIND_CENTER + TileSet.BIND_BOTTOM + TileSet.BIND_RIGHT + TileSet.BIND_BOTTOMRIGHT)
	tile_set.autotile_set_bitmask(0, Vector2(10, 2),
		TileSet.BIND_TOPLEFT + TileSet.BIND_LEFT + TileSet.BIND_TOP + TileSet.BIND_CENTER + TileSet.BIND_BOTTOM + TileSet.BIND_RIGHT + TileSet.BIND_BOTTOMRIGHT)
	tile_set.autotile_set_bitmask(0, Vector2(10, 3),
		TileSet.BIND_TOPLEFT + TileSet.BIND_LEFT + TileSet.BIND_TOP + TileSet.BIND_CENTER + TileSet.BIND_BOTTOM + TileSet.BIND_TOPRIGHT + TileSet.BIND_RIGHT)
	tile_set.autotile_set_bitmask(0, Vector2(11, 0),
		TileSet.BIND_LEFT + TileSet.BIND_BOTTOMLEFT + TileSet.BIND_CENTER + TileSet.BIND_BOTTOM)
	tile_set.autotile_set_bitmask(0, Vector2(11, 1),
		TileSet.BIND_TOPLEFT + TileSet.BIND_LEFT + TileSet.BIND_BOTTOMLEFT + TileSet.BIND_TOP + TileSet.BIND_CENTER + TileSet.BIND_BOTTOM + TileSet.BIND_RIGHT)
	tile_set.autotile_set_bitmask(0, Vector2(11, 2),
		TileSet.BIND_TOPLEFT + TileSet.BIND_LEFT + TileSet.BIND_BOTTOMLEFT + TileSet.BIND_TOP + TileSet.BIND_CENTER + TileSet.BIND_BOTTOM)
	tile_set.autotile_set_bitmask(0, Vector2(11, 3),
		TileSet.BIND_TOPLEFT + TileSet.BIND_LEFT + TileSet.BIND_TOP + TileSet.BIND_CENTER)
	ResourceSaver.save($VBox/OutputTileSet/LineEdit.text, tile_set)


func _on_folder_pressed(which: String) -> void:
	_which_folder = which
	match which:
		"input":
			dialog.mode = EditorFileDialog.MODE_OPEN_FILE
			dialog.clear_filters()
			dialog.add_filter("*.bmp, *.dds, *.exr, *.hdr, *.jpg, *.jpeg, *.png, *.tga, *.svg, *.svgz, *.webp; Images")
		"output_image":
			dialog.mode = EditorFileDialog.MODE_SAVE_FILE
			dialog.clear_filters()
			dialog.add_filter("*.bmp, *.dds, *.exr, *.hdr, *.jpg, *.jpeg, *.png, *.tga, *.svg, *.svgz, *.webp; Images")
		"output_tile_set":
			dialog.mode = EditorFileDialog.MODE_SAVE_FILE
			dialog.clear_filters()
			dialog.add_filter("*.tres, *.res; Resource File")
	dialog.popup_centered()


func _on_file_selected(file: String) -> void:
	$VBox.get_node(_which_folder.capitalize().replace(" ", "")).get_node("LineEdit").text = file
