package objs;

import flash.Vector;
import generation.City;
import generation.GridType;
import utils.Grid;
import utils.Vector2;
import haxeAStar.AStar;
import haxeAStar.IAStarClient;
import haxeAStar.IntPoint;
import haxeAStar.Node;

class Map implements IAStarClient {
// private:
  private var map_data: Array<Bool>;
  private var start_point : IntPoint;
  private var start_point_set : Bool;
// public:
  public var rowTotal(default, null):Int; // keep naming convention (part of
  public var colTotal(default, null):Int; // keep naming convention  iastar)

  public function new() : Void {
    var grid : Grid<GridType> = GameManager.city.object_grid;
    rowTotal = grid.width;
    colTotal = grid.height;
    map_data = new Array<Bool>();
    var t : Int = grid.height * grid.width;
    for ( i in 0 ... t ) {
      map_data.push(grid.get_1D(i) == GridType.NONE);
    }
    trace("map width: " + grid.width + ", height: " + grid.height);
    AStar.getAStarInstance(this).updateMap();
    trace("Done generating A*!");
  }

  // --- keep this naming convention as it's part of IAStarClient --
  public function isWalkable(x:Int, y:Int) : Bool {
    return map_data[y * colTotal + x];
  }

  public function ret_path(v1: Vector2, v2: Vector2) : Vector<IntPoint> {
    var p1: IntPoint = new IntPoint(Std.int(v1.x), Std.int(v1.y));
    var p2: IntPoint = new IntPoint(Std.int(v2.x), Std.int(v2.y));
    return AStar.getAStarInstance(this).findPath(p1, p2);
  }
}