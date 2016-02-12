package;

import openfl.display.DisplayObjectContainer;
import openfl.ui.Keyboard;

class Camera extends DisplayObjectContainer {

  var speed = 150;
  var screen_x = 800;
  var screen_y = 600;

  public function update(delta: Float) {

    if (Input.keys[Keyboard.A]) {
      x += delta * speed;
    }

    if (Input.keys[Keyboard.D]) {
      x -= delta * speed;
    }

    if (Input.keys[Keyboard.W]) {
      y += delta * speed;
    }

    if (Input.keys[Keyboard.S]) {
      y -= delta * speed;
    }

    if (-x < 0) {
      x = 0;
    } else if (-x > width - screen_x) {
      x = -width + screen_x;
    }

    if (-y < 0) {
      y = 0;
    }

    if (-y > height - screen_y) {
      y = -height + screen_y;
    }
  }
}