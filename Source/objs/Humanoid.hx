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
  private var move_timer: Float;
  public var behavior: Behavior;
  private var path_bitmap: Bitmap;

  public function new(x_: Float, y_: Float) {
    position = new Vector2(x_, y_);
    speed = 5;
    size = new Vector2(32, 32);
    move_timer = 0.0;

    behavior = Behavior.STAY;
  }

  public function update(delta: Float) {
    switch(behavior) {
      case STAY:
        path = null;
      case MOVE(x, y):
        var current_x = Math.floor(position.x/32);
        var current_y = Math.floor(position.y/32);
        if (path == null) {
          var start_node = GameManager.city.nodes.get(current_x, current_y);
          var end_node = GameManager.city.nodes.get(x, y);
          path = GameManager.city.pathfinder.construct_path(start_node, end_node, false);
          /*if (path_bitmap != null) { // debugging for paths
            Layers.Rem_Child(path_bitmap, Layers.LayerType.SPAWNER);
          }
          path_bitmap = new Bitmap(GameManager.city.pathfinder.bitmap_data);
          Layers.Add_Child(path_bitmap, Layers.LayerType.SPAWNER);*/
        }

        if (path.length > 0) {
          move_timer += delta * speed;

          if (path[0].x == current_x && path[0].y == current_y) {
            path.shift();
          }

          if (path.length > 0) {
            if (move_timer >= 1.0) {
              move_timer -= 1.0;
              position.x = path[0].x * 32;
              position.y = path[0].y * 32;
            }
          } else {
            behavior = Behavior.STAY;
          }
        } else {
          behavior = Behavior.STAY;
        }
      default:
    }

    // update image;
    image.x = position.x;
    image.y = position.y;
    image.width = size.x;
    image.height = size.y;
  }
}