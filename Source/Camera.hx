package;

import openfl.display.DisplayObjectContainer;
import openfl.ui.Keyboard;

class Camera extends DisplayObjectContainer {

  var speed = 150;

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
  }
}