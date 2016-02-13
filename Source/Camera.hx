package;

import openfl.display.DisplayObjectContainer;
import openfl.ui.Keyboard;
import openfl.geom.Rectangle;
import openfl.geom.Matrix;
import openfl.geom.Transform;
import utils.Vector2;
import openfl.events.MouseEvent;

class Camera extends DisplayObjectContainer {

  public var speed = 250;
  public var screen_x = 800;
  public var screen_y = 600;

  private var destination: Vector2;
  private var current: Vector2;

  private var current_scale = 1.0;
  private var max_scale = 0.75;
  private var min_scale = 1.5;

  public function new() {
    super();

    destination = new Vector2(0, 0);
    current = new Vector2(0, 0);

    addEventListener(MouseEvent.MOUSE_WHEEL, zoom);

  }

  public function zoom(event: MouseEvent) {
    if (event.delta > 3) {
      event.delta = 3;
    } else if (event.delta < -3) {
      event.delta = -3;
    }

    /*trace("Current Scale: " + current_scale);

    var delta = event.delta * 50;
    width += delta;
    height += delta;
    x += delta;
    y += delta;*/
  }

  public function Ret_Offset() : Vector2 { return destination; }

  public function update(delta: Float) {

    if (Input.keys[Keyboard.SHIFT]) {
      speed = 100;
    } else {
      speed = 250;
    }

    if (Input.keys[Keyboard.A]) {
      destination.x += delta * speed;
    }

    if (Input.keys[Keyboard.D]) {
      destination.x -= delta * speed;
    }

    if (Input.keys[Keyboard.W]) {
      destination.y += delta * speed;
    }

    if (Input.keys[Keyboard.S]) {
      destination.y -= delta * speed;
    }

    // Clamping
    if (-destination.x < 0) {
      destination.x = 0;
    } else if (-destination.x > width - screen_x) {
      destination.x = -width + screen_x;
    }

    if (-destination.y < 0) {
      destination.y = 0;
    }

    if (-destination.y > height - screen_y) {
      destination.y = -height + screen_y;
    }

    current = utils.Vector2.interpolate(current, destination, 0.8);
    x = current.x;
    y = current.y;
  }
}