package objs;

import openfl.display.Bitmap;
import utils.Util;
import utils.Vector2;
import objs.ZombieNodeSpawner;
import objs.UnitSelector;
import objs.Zombie;

class ZombieNodeSpawnerMenuTab {
//private:
  private static var backdrop : Bitmap = null;
  private static var goal_img : Bitmap = null;
  private static var dim: Vector2 = new Vector2(50, 160);
  private static var button_dim: Vector2 = new Vector2(50, 32);
  private var node: ZombieNodeSpawner;
  private var pos: Vector2;
  private var dragging: Bool;
//public static:
  public static function initialize() {
    backdrop = new Bitmap(Data.zombie_spawner_tab);
    backdrop.visible = false;
    goal_img = new Bitmap(Data.zombie_spawn_tab_goal);
    goal_img.visible = false;
    Layers.Add_Child(backdrop, LayerType.ZOMBIE_SPAWNER);
    Layers.Add_Child(goal_img, LayerType.ZOMBIE);
  }
// public:
  public function new(x_:Int, y_:Int, node_:ZombieNodeSpawner) {
    node = node_;
    pos = new Vector2(x_, y_);
    dragging = false;
    backdrop.x = x_;
    backdrop.y = y_;
    backdrop.visible = true;
    goal_img.visible = true;
    goal_img.x = node.Ret_Spawn_Goal().x;
    goal_img.y = node.Ret_Spawn_Goal().y;
  }
  public function destroy() {
    backdrop.visible = false;
    goal_img.visible = false;
  }
  public function click() : Void {
    if ( Util.PointCol(pos, dim, Input.mouse_pos) ) {
      var t: Vector2 = new Vector2(Std.int(pos.x), Std.int(pos.y));
      if ( Util.PointCol(t, button_dim, Input.mouse_pos) ) {
        GameManager.zombie_spawner_menu.destroy();
        return;
      }
      t.y += 32;
      if ( Util.PointCol(t, button_dim, Input.mouse_pos) ) {
        dragging = true;
        GameManager.unit_select.clear_select();
      }
    }
  }
  public function update() : Void {
    dragging = dragging && Input.mouse[Input.Mouse_left];
    if ( dragging ) {
      goal_img.x = Input.mouse_x - 8;
      goal_img.y = Input.mouse_y - 8;
      node.Set_Spawn_Goal(new Vector2(Input.mouse_x, Input.mouse_y));
    }
  }
  public function close() {
    backdrop.visible = false;
  }
}