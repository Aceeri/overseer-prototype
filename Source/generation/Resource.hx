package generation;

class Resource {
  public var available: Int;
  public var type: GridType;

  public function new(amount_: Int, type_: GridType) {
    available = amount_;
    type = type_;
  }

  public function get(amount_: Int) {
    available -= amount_;
  }
}