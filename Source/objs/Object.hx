package objs;

import openfl.display.Bitmap;
import utils.Vector2;
import openfl.geom.Point;

class Object {
	public var position: Vector2;
	public var velocity: Vector2;
	public var size: Vector2;
	public var image: Bitmap;

	public function new(x_: Float, y_: Float) {
		position = new Vector2(x_, y_);
		velocity = new Vector2();
		size = new Vector2(32, 32);
	}

	public function update(delta: Float) {
		position = position.add(velocity.scalar(delta));

		// update image;
		image.x = position.x;
		image.y = position.y;
		image.width = size.x;
		image.height = size.y;
	}
}