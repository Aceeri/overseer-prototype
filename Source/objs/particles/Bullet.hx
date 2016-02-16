package objs.particles;

import openfl.display.BitmapData;
import openfl.display.Bitmap;
import utils.Vector2;

class Bullet {
// CONSTS:
  public static inline var velocity: Float = 3.0;
// private:
  private var sh_beg : Vector2;
  private var sh_end : Vector2;
  private var iter   : Float;
  private var img : Bitmap;
// public:
  public function new(sh_beg_:Vector2, sh_end_:Vector2) : Void {
    sh_end = sh_beg_;
    sh_beg = sh_end_;
    iter   = 0;
    img = new Bitmap(Data.bullet);
    Layers.Add_Child(img, Layers.LayerType.OBJECTS);
    GameManager.bullets.push(this);
  }

  public function update(dt:Float) : Void {
    iter += dt*velocity;
    var t_pos : Vector2 = Vector2.interpolate(sh_beg, sh_end, iter);
    img.x = t_pos.x;
    img.y = t_pos.y;
    if ( iter > 1 ) {
      Layers.Rem_Child(img, Layers.LayerType.OBJECTS);
      GameManager.bullets.remove(this);
    }
  }
}