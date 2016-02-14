package path;

class Node {
  public var x: Float;
  public var y: Float;
  public var f: Float;
  public var g: Float;
  public var parent: Node;

  public function new(x_: Float, y_: Float) {
    x = x_;
    y = y_;
  }

  public function get_heuristic(from: Node): Float {
    return Math.sqrt(Math.pow(from.y - y, 2.0) + Math.pow(from.x - x, 2.0));
  }

  public function to_string(): String {
    return "(" + x + ", " + y + ")";
  }
}