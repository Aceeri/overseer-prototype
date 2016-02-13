package;

import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;

import ui.UserInterface;

class Interface {
  private static var sprite: Sprite = new Sprite();
  public static var list: Array<UserInterface> = [];

  public static function add_to(canvas: DisplayObjectContainer) {
    canvas.addChild(sprite);

    Input.listeners(sprite);
  }

  public static function remove_from(canvas: DisplayObjectContainer) {
    canvas.removeChild(sprite);
  }
  
  public static function add_interface(user_interface: UserInterface) {
    list.push(user_interface);
    sprite.addChild(user_interface);
  }

  public static function remove_interface(user_interface: UserInterface) {
    list.remove(user_interface);
    sprite.removeChild(user_interface);
  }
}