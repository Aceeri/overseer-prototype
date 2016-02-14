package utils;

import openfl.geom.Point;

class Vector2 extends Point {

  public function new(_x:Float = 0, _y:Float = 0) {
    super(_x, _y);
  }

  public function dot_product(vec: Vector2) : Float {
    return x*vec.x + y*vec.y;
  }

  public function distance(vec: Vector2) : Float {
    return Point.distance(this, vec);
  }

  public function to_string() : String {
    return x + ", " + y;
  }

  public static function interpolate(a:Vector2, b:Vector2, t:Float) : Vector2 {
    return new Vector2((1-t) * a.x + t * b.x,
                       (1-t) * a.y + t * b.y);
  }
}