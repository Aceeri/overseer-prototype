package objs.particles;

import utils.Vector2;

class Particle {
  public var iteration: Int;
  public var x: Int;
  public var y: Int;
  public var speed: Float;
  public var timer: Float;

  public function new(x_: Int, y_: Int) {
    x = x_;
    y = y_;
    speed = 1.0;
    iteration = 0;
    timer = 0.0;
  }
}