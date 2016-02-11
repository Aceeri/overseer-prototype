package generation;

import utils.Grid;

enum GridType {
  CROSSWALK;
  SIDEWALK;
  ROAD;
  WALL;
  FLOOR;
}

class City {
  private var grid: Grid<GridType>;

  // per 10
  private var double_size = 2;
  private var quad_size = 1;
  private var double_count = 0;
  private var quad_count = 0;
  
  public var block_size: Int;
  public var road_size: Int;
  public var width: Int;
  public var height: Int;

  public function new(width: Int, height: Int, block_size: Int = 10, road_size: Int = 5) {
    this.width = width;
    this.height = height;
    this.block_size = block_size;
    this.road_size = road_size;

    grid = new Grid(width * block_size + (width + 1) * road_size, height * block_size + (height + 1) * road_size, GridType.ROAD);

    generate();

    print();
  }

  private function generate() {
    var block_separator = road_size;

    for (block_x in 0...width) {
      for (block_y in 0...height) {
        var x = block_x * block_size + block_x * road_size + road_size;
        var y = block_y * block_size + block_y * road_size + road_size;

        grid.border(x - road_size, y - road_size, x, y, GridType.CROSSWALK);
        grid.border(x - road_size, y + block_size, x, y + block_size + road_size, GridType.CROSSWALK);
        grid.border(x + block_size, y - road_size, x + block_size + road_size, y, GridType.CROSSWALK);
        grid.border(x + block_size, y + block_size, x + block_size + road_size, y + block_size + road_size, GridType.CROSSWALK);
      }
    }

    for (block_x in 0...width) {
      for (block_y in 0...height) {
        var chance = Math.random();

        var x = block_x * block_size + block_x * road_size + road_size;
        var y = block_y * block_size + block_y * road_size + road_size;

        grid.fill(x, y, x + block_size, y + block_size, GridType.FLOOR);
        grid.border(x, y, x + block_size, y + block_size, GridType.WALL);
        grid.border(x - 1, y - 1, x + block_size + 1, y + block_size + 1, GridType.SIDEWALK);
      }
    }

    grid.border(0, 0, grid.width, grid.height, GridType.SIDEWALK);
  }

  private function print() {
    ui.Console.count_lines = false;
    for (y in 0...grid.height) {
      var current_line = "";
      for (x in 0...grid.width) {
        switch (grid.get(x, y)) {
          case CROSSWALK:
            current_line += ":";
          case SIDEWALK:
            current_line += "+";
          case ROAD:
            current_line += "~";
          case WALL:
            current_line += "|";
          case FLOOR:
            current_line += "-";
        }
      }
      trace(current_line);
    }
    ui.Console.count_lines = true;
  }
}