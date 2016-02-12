package generation;

import utils.Grid;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Assets;
import openfl.display.DisplayObjectContainer;
import openfl.display.DisplayObject;
import openfl.display.BitmapData;
import openfl.display.Bitmap;

class City {
  private var floor_grid: Grid<GridType>;
  private var object_grid: Grid<GridType>;
  private var size_floor_grid: Grid<Array<Point>>;

  private var parser: BuildingParser = new BuildingParser();
  private var list: BuildingList = new BuildingList();

  // per 10
  private var double_blocks: Int = 10;
  private var quad_blocks: Int = 3;

  private var block_size: Int = 10;
  private var road_size: Int = 6;

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

    var max_double = double_blocks;
    var max_quad = quad_blocks;

    // combine buildings
    combine(double_blocks, [new Point(0, 0), new Point(1, 0)]);
    combine(quad_blocks,
      [new Point(0, 0), new Point(1, 0), new Point(0, 1), new Point(1, 1)]);

    // draw buildings/sidewalks
    for (block_x in 0...width) {
      for (block_y in 0...height) {
        var cell = size_floor_grid.get(block_x, block_y);
        var start_x, end_x, start_y, end_y;

        if (cell.length == 2 || cell.length == 4) {
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
  }

  public function draw(canvas: DisplayObjectContainer) {
    var width = 16;
    var count = 0;

    var floor_bitmap = new BitmapData(width * floor_grid.width, width * floor_grid.height, true, 0x00FFFFFF);
    var object_bitmap = new BitmapData(width * object_grid.width, width * object_grid.height, true, 0x00FFFFFF);

    for (x in 0...floor_grid.width) {
      for (y in 0...floor_grid.height) {
        var bitmap = parser.as_bitmap(floor_grid.get(x, y));
        floor_bitmap.copyPixels(bitmap.bitmapData,
          new Rectangle(0, 0, width, width), new Point(x * width, y * width));
        count++;
      }
    }
    Layers.Add_Child(new Bitmap(floor_bitmap), Layers.LayerType.FLOOR);

    for (x in 0...object_grid.width) {
      for (y in 0...object_grid.height) {
        if (object_grid.get(x, y) != GridType.NONE) {
          var bitmap = parser.as_bitmap(object_grid.get(x, y));
          object_bitmap.copyPixels(bitmap.bitmapData,
            new Rectangle(0, 0, 16, 16), new Point(x * width, y * width));
          count++;
        }
      }
    }
    Layers.Add_Child(new Bitmap(object_bitmap), Layers.LayerType.OBJECTS);
    trace("Bitmap Count: " + count);
    trace("Total Canvas Children: " + canvas.numChildren);
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
    for (i in 0...max) {
      var x = Std.random(size_floor_grid.width);
      var y = Std.random(size_floor_grid.height);
      var cell = size_floor_grid.get(x, y);

      if (cell.length > 1) {
        continue;
      }

      var possibility = find_possibilities(x, y, layout);

      for (i in 0...possibility.length) {
        //trace(i + ": " + possibility[i]);
      }

      if (possibility.length == 0) {
        continue;
      }

      var use = possibility[Std.random(possibility.length)];
      for (j in 0...use.length) {
        size_floor_grid.set(Std.int(use[j].x), Std.int(use[j].y), use);
      }
    }
  }

  private function minmax(arr: Array<Point>): { min_x: Int, min_y: Int,
      max_x: Int, max_y: Int } {
    var mix = -1;
    var miy = -1;
    var max = -1;
    var may = -1;

    for (j in 0...arr.length) {
      if (mix == -1 || arr[j].x < mix) {
        mix = Std.int(arr[j].x);
      }

      if (max == -1 || arr[j].x > max) {
        max = Std.int(arr[j].x);
      }

      if (miy == -1 || arr[j].y < miy) {
        miy = Std.int(arr[j].y);
      }

      if (may == -1 || arr[j].y > may) {
        may = Std.int(arr[j].y);
      }
    }

    return {
      min_x: mix,
      min_y: miy,
      max_x: max,
      max_y: may
    }
  }
}