package generation;

//import js.html.File;
//import js.html.FileReader;

import openfl.Assets;
import openfl.geom.Point;
import generation.City.GridType;
import utils.Grid;

class BuildingParser {
	
	public function new() {

	}

	public function parse(path: String, width: Int, height: Int): Grid<GridType> {
		var content = Assets.getText(path);
		var grid = new Grid(width, height);

		for (content_index in 0...content.length) {
			var x = Math.floor(content_index / width);
			var y = content_index % height;
			//trace("Content: " + new Point(x, y));
			//grid.set()
		}

		return grid;
	}

	public function as_grid(char: String): GridType {
		switch(char) {
			case "|":
				return GridType.WALL;
			case "~":
				return GridType.ROAD;
			case ":":
				return GridType.CROSSWALK;
			case "+":
				return GridType.SIDEWALK;
			case "-":
				return GridType.FLOOR;
			default:
				return GridType.ROAD;
		}
	}

	public function as_char(type: GridType): String {
		return "";
	}
}