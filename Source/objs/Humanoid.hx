package objs;

import openfl.display.Bitmap;
import utils.Vector2;
import openfl.geom.Point;

class Humanoid {
// private statics:
  private static var health_bar_colours : Array<Int> = [
    0x21BA35,
    0xA1BA21,
    0xBA7A21,
    0xBA2121
  ];
// public:
  public var position: Vector2;
  public var velocity: Vector2;
  public var speed: Float;
  public var size: Vector2;
  public var image: Bitmap;
  public var health_bar: Shape;
  public var path: Array<Vector2>;
  public var behavior: Behavior;
// private:
  private var attack_timer: Float;
  private var move_timer: Float;
  private var path_bitmap: Bitmap;
  private var health: Int;
  private var max_health: Int;
  private var health_prev: Int;
  private var frame_attacked_humanoid: Humanoid;

  public function new(x_: Float, y_: Float, max_health_:Int) {
    position = new Vector2(x_, y_);
    speed = 5;
    size = new Vector2(32, 32);
    move_timer = 0.0;
    max_health = max_health_;

    behavior = Behavior.STAY;
  }

  public function destroy() : Void {

  }

  public function update(delta: Float) {
    if ( attack_timer <= 0 ) attack_timer -= delta;
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
      case ATTACK(humanoid):
        if ( attack_timer < 0 ) {
          frame_attacked_humanoid = humanoid;
        }
      default:
    }

    // update image
    image.x = position.x;
    image.y = position.y;
    image.width = size.x;
    image.height = size.y;
    health_bar.x = position.x;
    health_bar.y = position.y;
    if ( health != health_prev ) { // health changed
      health_prev = health;
      var h_dt : Float = health/health_max;
      health_bar.graphics.clear();
      var h_int : Int = Math.max(Math.min(3, Std.int(h_dt * 4)), 0);
      health_bar.graphics.beginFill(health_bar_colours[h_int]);
      health_bar.graphics.drawRect(0, 0, h_dt*32, 4);
      health_bar.graphics.endFill();
    }
  }

  public function add_health(hp:Int) : Void {
    health += hp;
  }
  public function ret_health() : Int { return health; }
}