package;

import openfl.Vector;

enum MouseButtons {
  LEFT;
  RIGHT;
  MIDDLE;
}

class Input {
  public static var keys: Vector<Bool>;
  public static var mouse: Vector<Bool>;
  public static var mouseX: Int;
  public static var mouseY: Int;

  public static function initialize() {
    Input.keys = new Vector<Bool>(200);
  }
}