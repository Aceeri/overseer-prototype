package path;

import openfl.geom.Point;

import utils.Grid;

class Pathfinder {
  private var nodes: Grid<Node>;
  private var cutoff: Int = 50;

  public function new(nodes_: Grid<Node>) {
    nodes = nodes_;
  }

  public function construct_path(start_node: Node, end_node: Node): Array<Point> {
    if (start_node == null || end_node == null) {
      trace("START OR END IS NULL");
      return [];
    }

    trace("Constructing Path: (" + start_node.x + ", " + start_node.y + ") to (" + end_node.x + ", " + end_node.y + ")");

    var open_set: Array<Node> = [];
    var closed_set: Array<Node> = [];

    var f: Float;
    var g: Float;

    start_node.g = 0;
    start_node.f = start_node.get_heuristic(end_node);
    open_set.push(start_node);

    var current: Node = start_node;
    var closest: Node = null;
    var low_dist: Float = start_node.get_heuristic(end_node);
    var count = 0;
    while (open_set.length > 0) {
      closed_set.push(current);

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
            return as_point(node_path);
          }
        }
      }

      var check = surrounding(current);

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
        }
      }

      if (current == end_node) {
        trace("FOUND PATH");
        var node_path = reconstruct_path(current);
        return as_point(node_path);
      }

      open_set.sort(sort);
      current = open_set.shift();
    }

    trace("EMPTY LIST");
    return [];
  }

  private function surrounding(node: Node): Array<Node> {
    var possible = [new Point(-1, -1), new Point(0, -1), new Point(1, -1),
                    new Point(-1, 0),                    new Point(1, 0),
                    new Point(-1, 1),  new Point(0, 1),  new Point(1, 1)];
    var result = [];

    for (index in 0...possible.length) {
      var coordinate = new Point(node.x + possible[index].x, node.y + possible[index].y);
      var x = Std.int(coordinate.x);
      var y = Std.int(coordinate.y);

      if (nodes.in_range(x, y)) {
        var new_node = nodes.get(x, y);
        if (new_node != null) {
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
    }

    return result;
  }

  private function as_point(arr: Array<Node>): Array<Point> {
    var point_path = [];

    for (index in 0...arr.length) {
      point_path[index] = new Point(arr[index].x, arr[index].y);
    }

    return point_path;
  }
}