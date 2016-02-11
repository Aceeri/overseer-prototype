package utils;

import utils.Vector2;

class CollisionInfo {
// public:
  public var collision: Bool,
             will_collide: Bool;
  public var translation: Vector2,
             projection : Vector2;
  public function new() {
    collision = 1;
    will_collide = 0;
  }
  public function new(c:Bool) {
    collision = c;
    will_collide = 0;
  }
  public function new(v:Vector2, c:Bool, wc:Bool) {
    collision = c;
    will_collide = wc;
    translation = v;
  }
}