package objs;

import openfl.display.Bitmap;
import utils.Vector2;

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
// public:
  public function new(x_:Int, y_:Int) {
    pos = new Vector2(x_, y_);
    dim = new Vector2(32, 32);
    img = new Bitmap(Data.zombie);
    img.x = Std.int(x_);
    img.y = Std.int(y_);
    Data.main.addChild(img);
    speed = Math.random() * Max_speed + Min_speed;
  }

  public function update() : Void {

  }
  public function ret_position():Vector2 { return pos; }
  public function ret_dimension():Vector2 { return dim; }
  public function set_position(x:Int, y:Int):Void {
    pos.x = x;
    pos.y = y;
  }
}