package generation;

import utils.Vector2;

class Resource {
  public var position: Vector2;
  public var available: Int;
  public var type: GridType;

  public function new(x_: Int, y_: Int, amount_: Int, type_: GridType) {
    position = new Vector2(x_, y_);
    available = amount_;
    type = type_;
  }
}