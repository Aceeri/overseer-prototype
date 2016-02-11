package generation;

import js.html.File;
import js.html.FileReader;

class BuildingParser {

	private var reader = new FileReader();
	
	public function new() {

	}

	public function parse(file: String): Array<GridType> {
		#if js
			var blob = new File(file);
			var label = "";
			reader.readAsText(blob, label);
			trace(blob + ", " + label);
		#end
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

		}
	}

	public function as_char(type: GridType): String {

	}
}