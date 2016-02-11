package utils;

import openfl.geom.Point;

class Vector2 extends Point {
  public function new(_x:Int, _y:Int) {
    super(_x, _y);
  }
  public function dot_product(vec:Vector2) : Float {
    return x*vec.x + y*vec.y;
  }
}