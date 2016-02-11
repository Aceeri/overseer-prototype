import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.Assets;


class Data {
  public static var zombie : BitmapData;
  public static var main : Sprite;

  public static function Load_Data(main_:Sprite) : Void {
    main = main_;
    zombie = Assets.getBitmapData("assets/zombie.png");
  }
}