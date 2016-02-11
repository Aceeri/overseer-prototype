package utils;

import openfl.geom.Point;

class Vector2 : Point {
  public function new(_x:Int, _y:Int) {
    x = _x;
    y = _y;
  }
  public function dot_product(vec:Vector2) : Float {
    return x*vec.x + y*vec.y;
  }
}