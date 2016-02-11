package;

import openfl.display.DisplayObject;
import openfl.display.Sprite;

class Layers {
  public static inline var Building: Int = 0;
  public static inline var Highlight: Int = 1;
  public static inline var Zombie: Int = 2;
  public static inline var Zombie_spawner: Int = 3;
  private static var layers = new Array<Sprite>();

  public static function initialize() : Void {
    for ( t in 0 ... 25 ) {
      layers.push(new Sprite());
      Data.main.addChild(layers[t]);
    }
  }

  public static function Add_Child(d: DisplayObject, layer:Int) : Void {
    layers[layer].addChild(d);
  }
  public static function Rem_Child(d: DisplayObject, layer:Int) : Void {
    layers[layer].removeChild(d);
  }
}