package utils;

class Grid<T> {
  public var width(default, null): Int;
  public var height(default, null): Int;

  private var content: Array<T>;

  public function new(width: Int, height: Int, fillValue: T = null) {
    this.width = width;
    this.height = height;
    clear(fillValue);
  }

  public function get(x: Int, y: Int): T {
    return content[y * width + x];
  }

  public function get_1D(x: Int): T {
    return content[x];
  }

  public function set(x: Int, y: Int, value: T) {
    if (in_range(x, y)) {
      content[y * width + x] = value;
    }
  }

  public inline function in_range(x: Int, y: Int):Bool {
    return x >= 0 && x < width && y >= 0 && y < height;
  }

  public function clear(fillValue: T = null) {
    content = [for (i in 0...width * height) fillValue];
  }

  public function fill(x1: Int, y1: Int, x2: Int, y2: Int, value: T) {
    for (x in x1...x2) {
      for (y in y1...y2) {
        set(x, y, value);
      }
    }
  }

  public function border(x1: Int, y1: Int, x2: Int, y2: Int, value: T) {
    fill(x1, y1, x2, y1 + 1, value);
    fill(x1, y1, x1 + 1, y2, value);
    fill(x2 - 1, y1, x2, y2, value);
    fill(x1, y2 - 1, x2, y2, value);
  }

  public function plug(x1: Int, y1: Int, x2: Int, y2: Int, plug: Grid<T>) {
    for (x in x1...x2) {
      for (y in y1...y2) {
        var value = plug.get(x - x1, y - y1);
        set(x, y, value);
      }
    }
  }
}