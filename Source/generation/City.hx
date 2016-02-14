package generation;

import utils.Grid;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Assets;
import openfl.display.DisplayObjectContainer;
import openfl.display.DisplayObject;
import openfl.display.BitmapData;
import openfl.display.Bitmap;

import path.Node;
import path.Pathfinder;

class City {
  private var floor_grid: Grid<GridType>;
  public var object_grid: Grid<GridType>;
  public var nodes: Grid<Node>; // use this for collision
  public var pathfinder: Pathfinder;
  private var size_floor_grid: Grid<Array<Point>>;
  private var resource_grid: Grid<Resource>;

  private var parser: BuildingParser = new BuildingParser();
  private var list: BuildingList = new BuildingList();

  // 2x1, 2x2, 2x3, 3x3
  //private var layout_ratios: Array<Float> = [ 0.17, 0.1, 0.08, 0.05 ];
  private var layout_ratios: Array<Float> = [ 1.0, 0.0, 0.0, 0.00 ];
  private var layouts: Array<Array<Point>> = [
    [new Point(0, 0), new Point(1, 0)],

    [new Point(0, 0), new Point(1, 0),
     new Point(0, 1), new Point(1, 1)],

    [new Point(0, 0), new Point(1, 0), new Point(2, 0),
     new Point(0, 1), new Point(1, 1), new Point(2, 1)],

    [new Point(0, 0), new Point(1, 0), new Point(2, 0),
     new Point(0, 1), new Point(1, 1), new Point(2, 1),
     new Point(0, 2), new Point(1, 2), new Point(2, 2)],
  ];

  private var tile: Int = 16;
  private var tile_size: Int = 32;
  private var object_bitmap: BitmapData;

  private var block_size: Int = 10;
  private var road_size: Int = 5;

  public var width: Int;
  public var height: Int;

  public function new(width: Int, height: Int) {
    this.width = width;
    this.height = height;

    floor_grid = new Grid(width * block_size + (width + 1) * road_size, height
      * block_size + (height + 1) * road_size, GridType.ROAD);
    object_grid = new Grid(floor_grid.width, floor_grid.height, GridType.NONE);
    size_floor_grid = new Grid(width, height, null);

    for (x in 0...width) {
      for (y in 0...height) {
        size_floor_grid.set(x, y, [new Point(x, y)]);
      }
    }

    generate();
  }

  private function generate() {
    var block_separator = road_size;

    // draw crosswalks
    for (block_x in 0...width) {
      for (block_y in 0...height) {
        var x = block_x * block_size + block_x * road_size + road_size;
        var y = block_y * block_size + block_y * road_size + road_size;

        floor_grid.border(x - road_size, y - road_size, x, y,
                                          GridType.CROSSWALK);
        floor_grid.border(x - road_size, y + block_size, x, y + block_size +
          road_size, GridType.CROSSWALK);
        floor_grid.border(x + block_size, y - road_size, x + block_size +
          road_size, y, GridType.CROSSWALK);
        floor_grid.border(x + block_size, y + block_size, x + block_size +
          road_size, y + block_size + road_size, GridType.CROSSWALK);
      }
    }

    var max_arr: Array<Int> = [];
    for (index in 0...layout_ratios.length) {
      max_arr[index] = Std.int(layout_ratios[index] * width * height);
    }

    // combine buildings
    for (i in 0...layouts.length) {
      var index = i;
      var layout = layouts[index];
      var max = max_arr[index];
      combine(max, layout);
    }

    // draw buildings/sidewalks
    for (block_x in 0...width) {
      for (block_y in 0...height) {
        var cell = size_floor_grid.get(block_x, block_y);
        var start_x, end_x, start_y, end_y;

        if (cell.length > 1) {
          var min_x: Int = -1;
          var min_y: Int = -1;
          var max_x: Int = -1;
          var max_y: Int = -1;

          for (i in 0...cell.length) {
            if (min_x == -1 || cell[i].x < min_x) {
              min_x = Std.int(cell[i].x);
            } else if (max_x == -1 || cell[i].x > max_x) {
              max_x = Std.int(cell[i].x);
            }

            if (min_y == -1 || cell[i].y < min_y) {
              min_y = Std.int(cell[i].y);
            } else if (max_y == -1 || cell[i].y > max_y) {
              max_y = Std.int(cell[i].y);
            }
          }

          start_x = min_x * block_size + min_x * road_size + road_size;
          end_x = max_x * block_size + max_x * road_size + road_size
                  + block_size;
          start_y = min_y * block_size + min_y * road_size + road_size;
          end_y = max_y * block_size + max_y * road_size + road_size
                  + block_size;
        } else {
          start_x = block_x * block_size + block_x * road_size + road_size;
          start_y = block_y * block_size + block_y * road_size + road_size;
          end_x = start_x + block_size;
          end_y = start_y + block_size;
        }

        var width = end_x - start_x;
        var height = end_y - start_y;
        var layout = list.get_layout(width + "x" + height);

        if (layout != "") {
          var plug = parser.parse(layout, width, height);

          floor_grid.plug(start_x, start_y, end_x, end_y, plug.floor);
          object_grid.plug(start_x, start_y, end_x, end_y, plug.object);
        } else {
          floor_grid.fill(start_x, start_y, end_x, end_y, GridType.FLOOR);
          object_grid.border(start_x, start_y, end_x, end_y, GridType.WALL);
        }

        floor_grid.border(start_x - 1, start_y - 1, end_x + 1, end_y + 1,
          GridType.SIDEWALK);
      }
    }

    floor_grid.border(0, 0, floor_grid.width, floor_grid.height, GridType.SIDEWALK);

    nodes = generate_nodes(object_grid);
    pathfinder = new Pathfinder(nodes);
  }

  public function draw(canvas: DisplayObjectContainer) {
    var count = 0;

    var floor_bitmap = new BitmapData(tile * floor_grid.width, tile * floor_grid.height, true, 0x00FFFFFF);
    object_bitmap = new BitmapData(tile * object_grid.width, tile * object_grid.height, true, 0x00FFFFFF);

    for (x in 0...floor_grid.width) {
      for (y in 0...floor_grid.height) {
        var data = parser.as_bitmap(floor_grid.get(x, y));

        if (floor_grid.get(x, y) != GridType.BLOCK) {
          floor_bitmap.copyPixels(data,
            new Rectangle(0, 0, data.width, data.height), new Point(x * tile, y * tile));
        }

        count++;
      }
    }
    var bitmap = new Bitmap(floor_bitmap);
    bitmap.width = tile_size * floor_grid.width;
    bitmap.height = tile_size * floor_grid.height;
    Layers.Add_Child(bitmap, Layers.LayerType.FLOOR);

    for (x in 0...object_grid.width) {
      for (y in 0...object_grid.height) {
        if (object_grid.get(x, y) != GridType.NONE) {
          var data = parser.as_bitmap(object_grid.get(x, y));

          if (object_grid.get(x, y) != GridType.BLOCK) {
            object_bitmap.copyPixels(data,
              new Rectangle(0, 0, data.width, data.height), new Point(x * tile, y * tile));
          }
          
          count++;
        }
      }
    }
    bitmap = new Bitmap(object_bitmap);
    bitmap.width = tile_size * object_grid.width;
    bitmap.height = tile_size * object_grid.height;
    Layers.Add_Child(bitmap, Layers.LayerType.OBJECTS);
    trace("Bitmap Count: " + count);
    trace("Total Canvas Children: " + canvas.numChildren);
  }

  public function modify(x: Int, y: Int, new_type: GridType) {
    var data = parser.as_bitmap(new_type);
    object_bitmap.copyPixels(data,
      new Rectangle(0, 0, tile, tile), new Point(x * tile, y * tile));
  }

  // [(0, 0), (1, 0)] 2x1
  // [(0, 0), (1, 0), (0, 1), (1, 1)] 2x2
  // [(0, 0), (1, 0), (2, 0), (0, 1), (1, 1), (2, 1)] 3x2
  // [(0, 0), (1, 0), (2, 0), (0, 1), (1, 1), (2, 1), (0, 2), (1, 2), (2, 2)] 3x3
  private function find_possibilities(x: Int, y: Int, layout: Array<Point>):
    Array<Array<Point>> {
    var coordinate = new Point(x, y);
    var possibility = [];

    for (anchor_index in 0...layout.length) {
      // (0, 0) first iteration
      // (1, 0) second iteration
      // (0, 1) third iteration
      // (1, 1) fourth iteration
      var anchor = layout[anchor_index];
      var possible = true;

      var offset_layout = new Array<Point>();
      for (offset_index in 0...layout.length) {
        offset_layout[offset_index] = layout[offset_index].subtract(anchor);
      }

      for (check_index in 0...offset_layout.length) {
        var position = offset_layout[check_index].add(coordinate); // correct on floor_grid
        if (!size_floor_grid.in_range(Std.int(position.x), Std.int(position.y))) {
          possible = false;
          break;
        }

        var cell = size_floor_grid.get(Std.int(position.x), Std.int(position.y));
        if (cell.length > 1) {
          possible = false;
          break;
        }
      }

      if (possible) {
        var correction = [];
        for (correction_index in 0...offset_layout.length) {
          correction[correction_index] = offset_layout[correction_index]
                                                              .add(coordinate);
        }
        possibility.push(correction);
      }
    }

    return possibility;
  }

  private function combine(max: Int, layout: Array<Point>) {
    var created = 0;
    for (i in 0...max) {
      var x = Std.random(size_floor_grid.width);
      var y = Std.random(size_floor_grid.height);
      var cell = size_floor_grid.get(x, y);

      if (cell.length > 1) {
        continue;
      }

      var possibility = find_possibilities(x, y, layout);

      if (possibility.length == 0) {
        continue;
      }

      var use = possibility[Std.random(possibility.length)];
      for (j in 0...use.length) {
        size_floor_grid.set(Std.int(use[j].x), Std.int(use[j].y), use);
      }

      created++;
    }

    trace("max: " + max + ", created: " + created);
  }

  private function get_partitions(data: BitmapData, size: Int): Grid<BitmapData> {
    var x_count = Math.ceil(data.width / size);
    var y_count = Math.ceil(data.height / size);
    var grid = new Grid<BitmapData>(x_count, y_count);

    for (x in 0...x_count) {
      for (y in 0...y_count) {
        var partition = new BitmapData(size, size);
        partition.copyPixels(data, new Rectangle(x, y, size, size), new Point());
        grid.set(x, y, partition);
      }
    }

    return grid;
  }

  private function generate_nodes(grid: Grid<GridType>): Grid<Node> {
    var node_grid = new Grid(grid.width, grid.height, null);

    for (x in 0...grid.width) {
      for (y in 0...grid.height) {
        if (grid.get(x, y) == GridType.NONE) {
          node_grid.set(x, y, new Node(x, y));
        }
      }
    }

    return node_grid;
  }
}