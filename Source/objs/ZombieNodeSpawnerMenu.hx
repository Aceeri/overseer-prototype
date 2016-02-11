package objs;

import openfl.display.Bitmap;
import utils.Vector2;
import utils.Util;
import objs.Zombie;
import objs.ZombieNodeSpawner;

class ZombieNodeSpawnerMenu {
// private:
  private static var backdrop : Bitmap = null;
  private static var dim: Vector2 = new Vector2(200, 398);
  private var node: ZombieNodeSpawner;
  private var pos: Vector2;
  private var prev_mouse : Bool;
// public:
  public function new(x_:Int, y_:Int, node_:ZombieNodeSpawner) {
    pos = new Vector2(x_, y_);
    backdrop.x = x_;
    backdrop.y = y_;
    backdrop.visible = true;
    trace(backdrop.visible);
    trace('Position: $x_ $y_ ');
    node = node_;
    prev_mouse = true; // we have to use this other than input's b/c
                       // input's update might  have this be false which
                       // will close out instantly
  }

  public static function initialize() {
    trace(Data.zombie_spawner_backdrop);
    backdrop = new Bitmap(Data.zombie_spawner_backdrop);
    backdrop.visible = false;
    Layers.Add_Child(backdrop, Layers.Zombie_spawner);
  }

  public function update() {
    if ( prev_mouse == false && Input.mouse[Input.Mouse_left] == true ) {
      // check click in range
      if ( Util.PointCol(pos, dim, Input.mouse_pos) ) {
        var t :Int = Std.int((Input.mouse_y - pos.y) / 77);
        if ( t < 0 || t > 4 ) return;
        var z_type : ZombieType = ZombieType.createByIndex(t);
        trace("Queueing " + z_type.getName() + " zombie");
        node.Add_To_Queue(z_type);
      } else {
        trace('Zombie spawner menu exited');
        GameManager.zombie_spawner_menu = null;
        backdrop.visible = false;
      }
    }
    prev_mouse = Input.mouse[Input.Mouse_left];
  }
}
