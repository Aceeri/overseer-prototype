package generation;

import utils.Grid;

enum GridType {
	SIDEWALK;
	ROAD;
	BUILDING;
	CEMENT;
}

class City {
	private var grid: Grid<GridType>;
	
	public var block_size: Int;
	public var road_size: Int;
	public var width: Int;
	public var height: Int;

	public function new(width: Int, height: Int, block_size: Int = 10, road_size: Int = 5) {
		this.width = width;
		this.height = height;
		this.block_size = block_size;
		this.road_size = road_size;

		grid = new Grid(width * block_size + width * road_size - road_size, height * block_size + width * road_size - road_size, GridType.CEMENT);

		generate();

		print();
	}

	private function generate() {
		var block_separator = road_size;

		for (block_x in 0...width) {
			for (block_y in 0...height) {
				var x = block_x * block_size + block_x * road_size;
				var y = block_y * block_size + block_y * road_size;

				grid.fill(x, y, x + block_size, y + block_size, GridType.BUILDING);

				grid.fill(x + block_size + 1, y, x + block_size + 1, y + block_size + 1, GridType.SIDEWALK);
			}
		}
	}

	private function print() {
		for (y in 0...grid.height) {
			var current_line = "";
			for (x in 0...grid.width) {
				switch (grid.get(x, y)) {
					case SIDEWALK:
						current_line += "s";
					case ROAD:
						current_line += "r";
					case BUILDING:
						current_line += "b";
					case CEMENT:
						current_line += "c";
				}
			}
			trace(current_line);
		}
	}
}