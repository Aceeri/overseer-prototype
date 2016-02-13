package generation;

import openfl.Assets;
import openfl.display.BitmapData;
import openfl.geom.Point;
import utils.Grid;

import haxe.ds.StringMap;
import haxe.ds.EnumValueMap;

class BuildingParser {
  private var floor = [
    // special
    { char: ".", type: GridType.NONE },
    { char: "?", type: GridType.UNKNOWN },

    // floor
    { char: "~", type: GridType.ROAD },
    { char: ":", type: GridType.CROSSWALK },
    { char: "+", type: GridType.SIDEWALK },
    { char: "-", type: GridType.FLOOR },
    { char: ";", type: GridType.GRASS },
  ];

  private var object = [
    // special
    { char: ".", type: GridType.NONE },
    { char: "?", type: GridType.UNKNOWN },
    { char: "*", type: GridType.UNKNOWN }, // DO NOT USE *
    
    // objects
    { char: "|", type: GridType.WALL },
    { char: "/", type: GridType.DOOR },
    { char: "[", type: GridType.FENCE },
    { char: "]", type: GridType.STONEWALL },
    { char: "t", type: GridType.TREE },
    { char: "t1", type: GridType.TREE1 },
    { char: "t2", type: GridType.TREE2 },
    { char: "t3", type: GridType.TREE3 },
    { char: "t4", type: GridType.TREE4 },
    { char: "t5", type: GridType.TREE5 },
    { char: "t6", type: GridType.TREE6 },
    { char: "t7", type: GridType.TREE7 },
    { char: "t8", type: GridType.TREE8 },
    { char: "t9", type: GridType.TREE9 },
    { char: "~", type: GridType.WATER },

    // resources
    { char: "w", type: GridType.WEAPON },
    { char: "a", type: GridType.AMMO },
    { char: "m", type: GridType.MEDICAL },
    { char: "f", type: GridType.FOOD },
  ];

  private var resources = [ "w", "a", "m", "f" ];

  private var char_map: StringMap<GridType>;
  private var grid_map: EnumValueMap<GridType, String>;
  
  public function new() {
    char_map = new StringMap();
    grid_map = new EnumValueMap();

    for (index in 0...floor.length) {
      char_map.set(floor[index].char, floor[index].type);
      grid_map.set(floor[index].type, floor[index].char);
    }

    for (index in 0...object.length) {
      char_map.set("*" + object[index].char, object[index].type);
      grid_map.set(object[index].type, "*" + object[index].char);
    }
  }

  public function parse(path: String, width: Int, height: Int): 
                              {
                                floor: Grid<GridType>, 
                                object: Grid<GridType>,
                                resource: Grid<Resource>
                              } {
    var content = Assets.getText(path);
    var upper = false;
    var partition = 0;

    var floor_grid = new Grid(width, height);
    var object_grid = new Grid(width, height);
    var resource_grid = new Grid(width, height);

    var count = 0;
    for (index in 0...content.length) {
      var x = Std.int(count % width);
      var y = Std.int(count / width);

      var char = content.charAt(index);

      if (upper && is_number(char)) {
        partition = Std.parseInt(Std.string(partition) + char);
        continue;
      }

      if (char == "^") {
        count = 0;
        upper = true;
      }
      
      if (char == "\r" || char == "\n") {
        continue;
      } else {
        if (!upper) {
          if (!floor_grid.in_range(x, y)) {
            continue;
          } else {
            floor_grid.set(x, y, as_grid(char));
          }
        } else {
          if (!object_grid.in_range(x, y)) {
            continue;
          } else {

            if (partition > 0) {
              char += partition;
              partition = 0;
            }

            object_grid.set(x, y, as_grid("*" + char));
          }
        }

        for (r in 0...resources.length) { 
          if (char == resources[r]) {
            // set resources
            var amount = 50;
            resource_grid.set(x, y, new Resource(amount, as_grid("*" + char)));
            break;
          }
        }

        count++;
      }
    }

    return {
      floor: floor_grid,
      object: object_grid,
      resource: resource_grid
    }
  }

  private function is_number(char: String): Bool {
    for (i in 0...10) {
      if (char == Std.string(i)) {
        return true;
      }
    }

    return false;
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

  public function as_bitmap(type: GridType): BitmapData {
    var data = Data.tile_map.get(Std.string(type));

    if (data == null) {
      data = new BitmapData(16, 16);
    }

    return data;
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