package ui;

import openfl.display.DisplayObjectContainer;
import openfl.display.DisplayObject;
import openfl.display.Bitmap;
import openfl.display.Shape;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.events.MouseEvent;
import openfl.Vector;

import haxe.ds.StringMap;

class UserInterface extends DisplayObjectContainer {
  public var children: StringMap<DisplayObject>;

  private var shape: Shape;
  private var prev_size: Point;
  private var prev_color: Int;
  private var prev_alpha: Float;

  public var background_color: Int;
  public var background_alpha: Float;
  public var size: Point;
  public var resizable: Bool;

  public function new() {
    super();

    children = new StringMap();

    background_color = 0xFFFFFF;
    background_alpha = 1.0;
    size = new Point(100, 100);
    resizable = false;

    shape = new Shape();
    addChild(shape);
  }

  public function update(delta: Float) {

    if (size != prev_size || background_color != prev_color ||
                             background_alpha != prev_alpha) {
      scrollRect = new Rectangle(0, 0, size.x, size.y);
      shape.graphics.clear();
      shape.graphics.beginFill(background_color, background_alpha);
      shape.graphics.drawRect(0, 0, size.x, size.y);
      shape.graphics.endFill();
    }

    for (child in children.iterator()) {
      if (Std.is(child, UserInterface)) {
        var user_interface = cast(child, UserInterface);
        user_interface.update(delta);

        if (visible != user_interface.visible) {
          user_interface.visible = visible;
        }
      }
    }
  }

  public function add(name: String, ui: UserInterface) {
    children.set(name, ui);
    addChild(ui);
  }

  public function remove(name: String) {
    removeChild(children.get(name));
    children.remove(name);
  }
}