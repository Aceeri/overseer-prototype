package utils;

class Vector2 {
  public var length (get, null):Float;
  public var x:Float;
  public var y:Float;

  public function new(x_: Float = 0, y_: Float = 0) {
    x = x_;
    y = y_;
  }

  public function dot_product(vec: Vector2) : Float {
    return x*vec.x + y*vec.y;
  }

  public function distance(vec: Vector2) : Float {
    var dx = x - vec.x;
    var dy = y - vec.y;
    return Math.sqrt(dx * dx + dy * dy);
  }

  // distance between two tiles of vectors, the vectors should not
  // be the tile position, rather the position of the object.
   public function distance_tile(vec:Vector2) : Float {
    var dx : Int = Std.int(x/32 - vec.y/32);
    var dy : Int = Std.int(y/32 - vec.y/32);
    return Math.sqrt(dx * dx + dy * dy);
  }

  public function to_string() : String {
    return '$x,  $y';
  }

  public function add(v:Vector2):Vector2 {
    return new Vector2(v.x + x, v.y + y);
  }

  public function sub(v:Vector2):Vector2 {
    return new Vector2 (x - v.x, y - v.y);
  }

  public function mul(v:Vector2):Vector2 {
    return new Vector2 (x * v.x, y * v.y);
  }

  public function div(v:Vector2):Vector2 {
    return new Vector2 (x / v.x, y / v.y);
  }

  public function scalar(f: Float): Vector2 {
    return new Vector2 (x * f, y * f);
  }

  public function clone ():Vector2 {
    return new Vector2(x, y);
  }

  public function copyFrom (sourceVector2:Vector2):Void {
    x = sourceVector2.x;
    y = sourceVector2.y;
  }

  public function equals (toCompare:Vector2):Bool {
    return toCompare != null && toCompare.x == x && toCompare.y == y;
  }

  public static function interpolate(pt1:Vector2, pt2:Vector2,
                                     f:Float): Vector2 {
    return new Vector2 (pt2.x + f * (pt1.x - pt2.x),
                        pt2.y + f * (pt1.y - pt2.y));
  }

  public function normalize (thickness:Float):Void {
    if (x == 0 && y == 0) {
      return;
    } else {
      var norm = thickness / Math.sqrt (x * x + y * y);
      x *= norm;
      y *= norm;
    }
  }

  public function offset (dx:Float, dy:Float):Void {
    x += dx;
    y += dy;
  }

  public static function polar (len:Float, angle:Float):Vector2 {
    return new Vector2 (len * Math.cos (angle), len * Math.sin (angle));
  }

  public function setTo (xa:Float, ya:Float):Void {
    x = xa;
    y = ya;
  }

  public function toString ():String {
    return '(x=$x, y=$y)';
  }

  // Getters & Setters
  public function get_length ():Float {
    return Math.sqrt (x * x + y * y);
  }
}