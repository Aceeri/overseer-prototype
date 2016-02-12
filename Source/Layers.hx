package;

import openfl.display.DisplayObject;
import openfl.display.Sprite;

enum LayerType {
  FLOOR;
  BUILDING;
  HIGHLIGHT;
  ZOMBIE;
  ZOMBIE_SPAWNER;
  OBJECTS;
}

class Layers {
  private static var layers = new Array<Sprite>();

  public static function initialize() : Void {
    for ( t in 0 ... 25 ) {
      layers.push(new Sprite());
      Data.main.addChild(layers[t]);
    }
  }

  public static function Add_Child(d: DisplayObject, layer:LayerType) : Void {
    layers[layer.getIndex()].addChild(d);
  }
  public static function Rem_Child(d: DisplayObject, layer:LayerType) : Void {
    layers[layer.getIndex()].removeChild(d);
  }
}