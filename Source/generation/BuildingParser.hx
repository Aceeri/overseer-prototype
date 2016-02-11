package generation;

//import js.html.File;
//import js.html.FileReader;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.geom.Point;
import generation.City.GridType;
import utils.Grid;

import haxe.ds.StringMap;
import haxe.ds.EnumValueMap;

class BuildingParser {
	private var associations = [
		{ char: "|", type: GridType.WALL },
		{ char: "~", type: GridType.ROAD },
		{ char: ":", type: GridType.CROSSWALK },
		{ char: "+", type: GridType.SIDEWALK },
		{ char: "-", type: GridType.FLOOR },
		{ char: "/", type: GridType.DOOR },
		{ char: "?", type: GridType.UNKNOWN }
	];

	private var char_map: StringMap<GridType>;
	private var grid_map: EnumValueMap<GridType, String>;
	
	public function new() {
		char_map = new StringMap();
		grid_map = new EnumValueMap();

		for (index in 0...associations.length) {
			char_map.set(associations[index].char, associations[index].type);
			grid_map.set(associations[index].type, associations[index].char);
		}
	}

	public function parse(path: String, width: Int, height: Int): Grid<GridType> {
		var content = Assets.getText(path);
		var grid = new Grid(width, height);

		var count = 0;
		for (index in 0...content.length) {
			var x = Std.int(count % width);
			var y = Std.int(count / width);

			var char = content.charAt(index);
			
			if (char == "\r" || char == "\n" || !grid.in_range(x, y)) {
				continue;
			} else {
				grid.set(x, y, as_grid(char));
				count++;
			}
		}

		//print(grid);

		return grid;
	}

	public function as_grid(char: String): GridType {
		var cell = char_map.get(char);

		if (cell == null) {
			return GridType.UNKNOWN;
		}

		return cell;
	}

	public function as_char(type: GridType): String {
		var char = grid_map.get(type);

		if (char == null) {
			return "?";
		}

		return char;
	}

	public function as_bitmap(type: GridType): Bitmap {
		var data = Data.tile_map.get(Std.string(type));
		var bitmap;

		if (data == null) {
			bitmap = new Bitmap();
		} else {
			bitmap = new Bitmap(data);
		}

		return bitmap;
	}

	public function print(grid: Grid<GridType>) {
		ui.Console.count_lines = false;
		for (y in 0...grid.height) {
			var current_line = "";
			for (x in 0...grid.width) {
				current_line += as_char(grid.get(x, y));
			}
			trace(current_line);
		}
		ui.Console.count_lines = true;
	}
}