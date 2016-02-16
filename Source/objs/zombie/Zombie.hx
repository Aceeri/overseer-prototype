package objs.zombie;

import flash.Vector;
import openfl.display.Bitmap;
import utils.Vector2;
import openfl.geom.Point;

enum ZombieType {
  Normal;
  Banshee;
  Hulk;
  Ghost;
  Stripper;
}

class Zombie extends Humanoid {
// CONSTS:
  public static inline var Max_speed: Float = 10.0;
  public static inline var Min_speed: Float = 2.0;
// private:
// public:
  public function new(x_:Int, y_:Int) {
    super(x_, y_);
    image = new Bitmap(Data.zombie);
    Layers.Add_Child(image, Layers.LayerType.HUMANOID);
    speed = Math.random() * Max_speed + Min_speed;
  }

  override public function destroy() : Void {
    super.destroy();
    Layers.Rem_Child(image, Layers.LayerType.HUMANOID);
  }

  override public function update(dt:Float) : Void {
    super.update(dt);
    if ( health <= 0 ) {
      destroy();
    }
  }

  public function ret_position():Vector2 { return position; }
  public function ret_dimension():Vector2 { return size; }
  public function set_position(x:Int, y:Int) {
    position.x = x;
    position.y = y;
  }
  public function set_target_pos(v:Vector2) {
    behavior = Behavior.MOVE(Std.int(v.x / 32), Std.int(v.y / 32));
  }
}
