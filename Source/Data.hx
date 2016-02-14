package;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObjectContainer;
import openfl.Assets;
import openfl.Assets.AssetType;

import generation.GridType;
import haxe.ds.StringMap;

class Data {
  public static var zombie : BitmapData;
  public static var main : DisplayObjectContainer;
  public static var zombie_spawner : BitmapData;
  public static var zombie_spawner_backdrop : BitmapData;
  public static var zombie_spawner_queue : BitmapData;
  public static var zombie_icons : Array<BitmapData>;
  public static var zombie_spawn_tab_goal : BitmapData;
  public static var zombie_spawner_tab : BitmapData;

  public static var tile_map: StringMap<BitmapData>;
  public static var image_map: StringMap<BitmapData>;

  private static function load ( s : String ) {
    return Assets.getBitmapData(s);
  }

  public static function load_data(main_: DisplayObjectContainer) {
    main = main_;
    zombie                  = load("assets/zeds/zombie.png");
    zombie_spawner          = load("assets/zeds/zombie_spawner.png");
    zombie_spawner_backdrop = load("assets/zeds/zombie_spawn_menu.png");
    zombie_spawner_queue    = load("assets/zeds/zombie_spawn_menu_queue.png");
    zombie_spawner_tab      = load("assets/zeds/zombie_spawn_menu_tab.png");
    zombie_spawn_tab_goal = load("assets/zeds/zombie_spawn_menu_tab_goal.png");
    zombie_icons            = [
      load("assets/zeds/zombie_ico.png"),
      load("assets/zeds/banshee_ico.png"),
      load("assets/zeds/hulk_ico.png"),
      load("assets/zeds/zombie_ico.png"),
      load("assets/zeds/zombie_ico.png")
    ];

    load_tiles();
    load_images();
  }

  public static function load_tiles() {
    tile_map = new StringMap();

    var files = Assets.list(AssetType.IMAGE);
    for (index in 0...files.length) {
      var path = files[index];
      var regex = ~/assets\/tiles\/(.+)\..+/;
      var matched = regex.match(path);

      if (matched) {
        tile_map.set(regex.matched(1), load(path));
      }
    }
  }

  public static function load_images() {
    image_map = new StringMap();

    var files = Assets.list(AssetType.IMAGE);
    for (index in 0...files.length) {
      var path = files[index];
      var regex = ~/assets\/images\/(.+)\..+/;
      var matched = regex.match(path);

      if (matched) {
        trace("MATCHED: " + regex.matched(1));
        image_map.set(regex.matched(1), load(path));
      }
    }
  }
}
