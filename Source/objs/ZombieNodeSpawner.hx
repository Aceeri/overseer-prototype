package objs;

import objs.Zombie;
import objs.ZombieNodeSpawnerMenu;
import openfl.display.Bitmap;
import utils.Util;
import utils.Vector2;

class ZombieNodeSpawner {
//private:
  private var spawn_queue: Array<ZombieType>;
  private var pos: Vector2;
  private static var dim: Vector2 = new Vector2(32, 32);
  private var timer:Float;
  private var img: Bitmap;
//public:
  public function new(x_:Int, y_:Int) {
    pos = new Vector2(x_, y_);
    timer = 0;
    spawn_queue = [];
    img = new Bitmap(Data.zombie_spawner);
    trace(img);
    img.x = x_;
    img.y = y_;
    Layers.Add_Child(img, Layers.LayerType.ZOMBIE_SPAWNER);
  }
  public function Add_To_Queue(zt:ZombieType) {
    spawn_queue.insert(0, zt);
  }
  public function update() {
    // -- check if zombies queued --
    if ( timer < 0 ) {
      if ( spawn_queue.length > 0 ) {
        var t: ZombieType = spawn_queue.pop();
        GameManager.zombies.push(new Zombie(Std.int(pos.x), Std.int(pos.y)));
        timer = 5;
      }
    } else
      timer -= GameManager.dt;

    // -- check if mouse clicked on us --
    if ( Input.mouse     [Input.Mouse_left] == true &&
         Input.mouse_prev[Input.Mouse_left] == false ) {
      if ( Util.PointCol(pos, dim, Input.mouse_pos) ) {
        GameManager.zombie_spawner_menu =
          new ZombieNodeSpawnerMenu(Std.int(pos.x) + 40,
                            Std.int(pos.y) - 120, this);
      }
    }
 }
}