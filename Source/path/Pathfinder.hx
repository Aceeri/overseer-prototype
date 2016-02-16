package path;

import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;

import utils.Vector2;
import utils.Grid;

class Pathfinder {
  private var nodes: Grid<Node>;
  private var clone: Grid<Node>;
  private var cutoff: Int = 500;
  public var bitmap_data: BitmapData;

  public function new(nodes_: Grid<Node>) {
    nodes = nodes_;
    clear();
  }

  public function construct_path(start_node: Node, end_node: Node, ?cut_corner: Bool = false): Array<Vector2> {
    //bitmap_data = new BitmapData(nodes.width * 32, nodes.height * 32, true, 0x00FFFFFF);
    clear();

    if (start_node == null || end_node == null) {
      trace("START OR END IS NULL");
      return [];
    }

    //set_bitmap(end_node, 0xAAFFFFFF);

    trace("Constructing Path: (" + start_node.x + ", " + start_node.y + ") to (" + end_node.x + ", " + end_node.y + ")");

    var open_set: Array<Node> = [];
    var closed_set: Array<Node> = [];

    var f: Float;
    var g: Float;

    start_node.g = 0;
    start_node.f = start_node.get_heuristic(end_node);
    open_set.push(start_node);
    //set_bitmap(start_node);

    var current: Node = start_node;
    var closest: Node = null;
    var low_dist: Float = start_node.get_heuristic(end_node);
    var count = 0;
    while (open_set.length >= 0 || current != null) {
      closed_set.push(current);
      //set_bitmap(current, 0xAA333333);

      if (current.get_heuristic(end_node) < low_dist) {
        closest = current;
        low_dist = current.get_heuristic(end_node);
        count = 0;
      } else {
        count++;

        if (count == cutoff) {
          trace("CLOSEST, NO PATH");
          if (closest == null) {
            return [];
          } else {
            var node_path = reconstruct_path(closest);
            return as_vector2(node_path);
          }
        }
      }

      var check = surrounding(current, cut_corner);

      for (index in 0...check.length) {
        var node = check[index];

        g = current.g + node.get_heuristic(current);
        f = g + node.get_heuristic(end_node);

        if (closed_set.indexOf(node) != -1 || open_set.indexOf(node) != -1) {
          if (node.f > f) {
            node.f = f;
            node.g = g;
            node.parent = current;
          }
        } else {
          node.f = f;
          node.g = g;
          node.parent = current;
          open_set.push(node);
          //set_bitmap(node);
        }
      }

      if (current == end_node) {
        trace("FOUND PATH");
        var node_path = reconstruct_path(current);
        return as_vector2(node_path);
      }

      open_set.sort(sort);
      current = open_set.shift();
      //set_bitmap(current, 0xAAFF0000);
    }

    trace("EMPTY LIST");
    return [];
  }

  private function clear() {
    clone = new Grid(nodes.width, nodes.height);

    for (x in 0...nodes.width) {
      for (y in 0...nodes.height) {
        var node = nodes.get(x, y);
        if (node == null) {
          clone.set(x, y, null);
        } else {
          clone.set(x, y, node.clone());
        }
      }
    }

    nodes = clone;
  }

  private function surrounding(node: Node, ?cut_corner: Bool = false): Array<Node> {
    var possible = [new Vector2(-1, -1), new Vector2(0, -1), new Vector2(1, -1),
                    new Vector2(-1, 0),                      new Vector2(1, 0),
                    new Vector2(-1, 1),  new Vector2(0, 1),  new Vector2(1, 1)];
    var result = [];

    for (index in 0...possible.length) {
      var coordinate = new Vector2(node.x + possible[index].x, node.y + possible[index].y);
      var x = Std.int(coordinate.x);
      var y = Std.int(coordinate.y);

      if (nodes.in_range(x, y)) {
        var new_node = nodes.get(x, y);

        var valid = true;

        if (!cut_corner && (index == 0 || index == 2 || index == 5 || index == 7)) {
          var node1 = nodes.get(x - Std.int(possible[index].x), y);
          var node2 = nodes.get(x, y - Std.int(possible[index].y));

          if (node1 == null || node2 == null) {
            valid = false;
          }
        }

        if (new_node != null && valid) {
          result.push(new_node);
        }
      }
    }

    return result;
  }

  private function sort(x: Node, y: Node): Int {
    return Std.int(x.f - y.f);
  }

  private function best_node(arr: Array<Node>, end: Node): Node {
    var best_score = -1.0;
    var best_node = null;

    for (i in 0...arr.length) {
      var score = arr[i].get_heuristic(end);

      if (score < best_score || best_score == -1.0) {
        best_score = score;
        best_node = arr[i];
      }
    }

    return best_node;
  }

  private function reconstruct_path(node: Node): Array<Node> {
    var result = [];

    while (node.parent != null) {
      result.insert(0, node);
      node = node.parent;
      //set_bitmap(node, 0xAA0000FF);
    }

    return result;
  }

  private function as_vector2(arr: Array<Node>): Array<Vector2> {
    var point_path = [];

    for (index in 0...arr.length) {
      point_path[index] = new Vector2(arr[index].x, arr[index].y);
    }

    return point_path;
  }

  private function set_bitmap(node: Node, ?color: Int = 0xAA00FF00) {
    var data = new BitmapData(32, 32, true, color);
    bitmap_data.copyPixels(data, new Rectangle(0, 0, 32, 32), new Point(node.x * 32, node.y * 32));
  }
}