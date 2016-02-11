package ui;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.Shape;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.events.MouseEvent;
import openfl.Vector;

class UserInterface extends Sprite {
  public var children: Vector<UserInterface> = [];

  private var shape: Shape;
  private var prev_size: Point;
  private var prev_color: Int;
  private var prev_alpha: Float;

  public var background_color: Int;
  public var background_alpha: Float;
  public var image: Bitmap;
  public var size: Point;
  public var resizable: Bool;

  public function new() {
    super();

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

  }

  public function add(ui: UserInterface) {
    children.push(ui);
    addChild(ui);
  }

  public function remove(ui: UserInterface) {
    children.slice(children.indexOf(ui));
    removeChild(ui);
  }
}