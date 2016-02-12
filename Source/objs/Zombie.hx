package objs;

import openfl.display.Bitmap;
import utils.Vector2;

enum ZombieType {
  Normal;
  Banshee;
  Hulk;
  Ghost;
  Stripper;
}

class Zombie {
// CONSTS:
  public static inline var Max_speed: Float = 10.0;
  public static inline var Min_speed: Float = 2.0;
// private:
  private var img : Bitmap;
  private var pos : Vector2;
  private var dim : Vector2;
  private var speed: Float;
  private var width: Int;
  private var height: Int;
  private var target: Vector2;
// public:
  public function new(x_:Int, y_:Int) {
    pos = new Vector2(x_, y_);
    dim = new Vector2(32, 32);
    img = new Bitmap(Data.zombie);
    img.x = Std.int(x_);
    img.y = Std.int(y_);
    Layers.Add_Child(img, Layers.LayerType.ZOMBIE);
    speed = Math.random() * Max_speed + Min_speed;
    target = new Vector2(x_, y_);
  }

  public function update() : Void {
    if ( target.distance( pos ) > 10 ) {
      trace("Moving");
      if ( target.x > pos.x ) pos.x += 0.6;
      else                    pos.x -= 0.6;
      if ( target.y > pos.y ) pos.y += 0.6;
      else                    pos.y -= 0.6;
    }

    img.x = pos.x;
    img.y = pos.y;
  }

  public function ret_position():Vector2 { return pos; }
  public function ret_dimension():Vector2 { return dim; }
  public function set_position(x:Int, y:Int):Void {
    pos.x = x;
    pos.y = y;
  }
  public function set_target_pos(v:Vector2):Void {
      target.x = v.x;
      target.y = v.y;
  }
}