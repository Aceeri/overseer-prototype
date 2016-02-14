package objs.zombie;

import openfl.display.Bitmap;
import utils.Vector2;
import utils.Util;
import objs.zombie.Zombie;
import objs.zombie.ZombieNodeSpawner;
import objs.zombie.ZombieNodeSpawnerMenuQueue;
import objs.zombie.ZombieNodeSpawnerMenuTab;

class ZombieNodeSpawnerMenu {
// private:
  private static var backdrop : Bitmap = null;
  private static var dim: Vector2 = new Vector2(200, 398);
  private var queue: ZombieNodeSpawnerMenuQueue;
  private var tab: ZombieNodeSpawnerMenuTab;
  private var node: ZombieNodeSpawner;
  private var pos: Vector2;
  private var o_pos: Vector2;
  private var prev_mouse : Bool;
// public:
  public function new(x_:Int, y_:Int, node_:ZombieNodeSpawner) {
    node = node_;
    x_ = Std.int(400 - dim.x/2);
    y_ = Std.int(300 - dim.y/2);
    pos   = new Vector2(x_, y_);
    o_pos = new Vector2(x_, y_);
    backdrop.x = x_;
    backdrop.y = y_;
    backdrop.visible = true;
    queue = new ZombieNodeSpawnerMenuQueue(x_, y_-32, node);
    tab   = new ZombieNodeSpawnerMenuTab(x_+200, y_, node);
    prev_mouse = true; // we have to use this other than input's b/c
                       // input's update might  have this be false which
                       // will close out instantly
  }
  public function destroy() : Void {
    queue.destroy();
    tab.destroy();
    backdrop.visible = false;
    GameManager.zombie_spawner_menu = null;
  }

  public static function initialize() {
    backdrop = new Bitmap(Data.zombie_spawner_backdrop);
    backdrop.visible = false;
    Layers.Add_Child(backdrop, Layers.LayerType.ZOMBIE_SPAWNER);
    ZombieNodeSpawnerMenuTab.initialize();
    ZombieNodeSpawnerMenuQueue.initialize();
  }

  public function update() {
    if ( prev_mouse == false && Input.mouse[Input.Mouse_left] == true ) {
      tab.click();
      // check click in range
      if ( Util.PointCol(pos, dim, Input.mouse_pos) ) {
        var t :Int = Std.int((Input.mouse_y - pos.y) / 77);
        if ( t < 0 || t > 4 ) return;
        var z_type : ZombieType = ZombieType.createByIndex(t);
        trace("Queueing " + z_type.getName() + " zombie");
        queue.push_queue(ZombieType.Normal);//FIXME
        node.Add_To_Queue(z_type);
      }
    }
    tab.update();
    var offset : Vector2 = GameManager.camera.Ret_Offset();
    tab.set_pos  (Std.int(-offset.x + o_pos.x+200),
                  Std.int(-offset.y + o_pos.y-32));
    queue.set_pos(Std.int(-offset.x + o_pos.x),
                  Std.int(-offset.y + o_pos.y-32));
    backdrop.x = -offset.x + o_pos.x;
    backdrop.y = -offset.y + o_pos.y;
    pos.x      = -offset.x + o_pos.x;
    pos.y      = -offset.y + o_pos.y;
    prev_mouse = Input.mouse[Input.Mouse_left];
  }

  public function push_queue(t:ZombieType) : Void {
    queue.push_queue(t);
  }
  public function pop_queue() : Void {
    queue.pop_queue();
  }
}
