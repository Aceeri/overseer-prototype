package objs;

import openfl.display.Bitmap;
import utils.Util;
import utils.Vector2;
import objs.ZombieNodeSpawner;
import objs.Zombie;

class ZombieNodeSpawnerMenuQueue {
//private:
  private static var backdrop : Bitmap = null;
  private static var dim: Vector2 = new Vector2(192, 32);
  private var node: ZombieNodeSpawner;
  private var pos: Vector2;
  private var prev_mouse: Bool;
  private var queue: Array<Bitmap>;
//public static:
  public static function initialize() {
    backdrop = new Bitmap(Data.zombie_spawner_queue);
    backdrop.visible = false;
    Layers.Add_Child(backdrop, LayerType.ZOMBIE_SPAWNER);
  }
// public:
  public function new(x_:Int, y_:Int, node_:ZombieNodeSpawner) {
    pos = new Vector2(x_, y_);
    queue = [];
    backdrop.x = x_;
    backdrop.y = y_;
    backdrop.visible = true;
    node = node_;
    // -- reap zombies in queue --
    var t_queue: Array<ZombieType> = node.Ret_Queue();
    for ( q in t_queue ) {
      push_queue(ZombieType.Normal); // todo, set this to actual type
    }
  }
  public function destroy() {
    while ( queue.length != 0 )
      Layers.Rem_Child(queue.pop(), LayerType.ZOMBIE_SPAWNER);
    backdrop.visible = false;
  }
  public function pop_queue() {
    Layers.Rem_Child(queue.pop(), LayerType.ZOMBIE_SPAWNER);
  }
  public function push_queue(type:ZombieType) {
      var t : Int = type.getIndex();
      var bm : Bitmap = new Bitmap(Data.zombie_icons[t]);
      bm.x = backdrop.x + queue.length*32;
      bm.y = backdrop.y;
      Layers.Add_Child(bm, LayerType.ZOMBIE_SPAWNER);
      queue.push(bm);
  }
  public function close() {
    backdrop.visible = false;
  }
}