package;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.Assets;
import openfl.Assets.AssetType;

import generation.City.GridType;
import haxe.ds.StringMap;

class Data {
  public static var zombie : BitmapData;
  public static var main : Sprite;
  public static var zombie_spawner : BitmapData;
  public static var zombie_spawner_backdrop : BitmapData;

  public static var tile_map: StringMap<BitmapData>;

  public static function load_data(main_:Sprite) {
    main = main_;
    zombie = Assets.getBitmapData("assets/zombie.png");
    zombie_spawner = Assets.getBitmapData("assets/zombie_spawner.png");
    zombie_spawner_backdrop =
              Assets.getBitmapData("assets/zombie_spawn_menu.png");

    load_tiles();
  }

  public static function load_tiles() {
    tile_map = new StringMap();

    var files = Assets.list(AssetType.IMAGE);
    for (index in 0...files.length) {
      var path = files[index];
      var regex = ~/assets\/tiles\/(.+)\..+/;
      var matched = regex.match(path);

      if (matched) {
        tile_map.set(regex.matched(1), Assets.getBitmapData(path));
      }
    }

    /*var item_iter = tile_map.iterator();
    var key_iter = tile_map.keys();
    while (true) {
      if (key_iter.hasNext() && item_iter.hasNext()) {
        trace(key_iter.next() + ": " + item_iter.next());
      } else {
        break;
      }
    }*/
  }
}