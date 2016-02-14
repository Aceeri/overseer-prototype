package objs;

import openfl.display.Bitmap;
import utils.Vector2;
import openfl.geom.Point;

class Humanoid {
  public var position: Vector2;
  public var velocity: Vector2;
  public var speed: Float;
  public var size: Vector2;
  public var image: Bitmap;
  public var path: Array<Vector2>;
  private var next_node: Vector2;
  public var behavior: Behavior;

  public function new(x_: Float, y_: Float) {
    position = new Vector2(x_, y_);
    velocity = new Vector2();
    speed = 250;
    size = new Vector2(32, 32);

    behavior = Behavior.STAY;
  }

  public function update(delta: Float) {

    switch(behavior) {
      case STAY:
        path = null;
        velocity = new Vector2();
      case MOVE(x, y):
        var current_x = Math.floor(position.x/32);
        var current_y = Math.floor(position.y/32);
        if (path == null) {
          var start_node = GameManager.city.nodes.get(current_x, current_y);
          var end_node = GameManager.city.nodes.get(x, y);
          path = GameManager.city.pathfinder.construct_path(start_node, end_node);
        }

        if (path.length > 0) {
          if (path[0].x == current_x && path[0].y == current_y) {
            path.shift();
          }

          if (path.length > 0) {
            velocity = path[0].sub(new Vector2(current_x, current_y));
            velocity.normalize(1);
          } else {
            behavior = Behavior.STAY;
            velocity = new Vector2();
          }
        } else {
          behavior = Behavior.STAY;
          velocity = new Vector2();
        }
      default:
    }

    position = position.add(velocity.scalar(delta).scalar(speed));

    // update image;
    image.x = position.x;
    image.y = position.y;
    image.width = size.x;
    image.height = size.y;
  }
}