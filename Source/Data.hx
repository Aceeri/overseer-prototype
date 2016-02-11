import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.Assets;


class Data {
  public static var zombie : BitmapData;
  public static var main : Sprite;
  public static var zombie_spawner : BitmapData;
  public static var zombie_spawner_backdrop : BitmapData;

  public static function Load_Data(main_:Sprite) : Void {
    main = main_;
    zombie = Assets.getBitmapData("assets/zombie.png");
    zombie_spawner = Assets.getBitmapData("assets/zombie_spawner.png");
    zombie_spawner_backdrop =
              Assets.getBitmapData("assets/zombie_spawn_menu.png");
  }
}