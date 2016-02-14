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
		size = new Vector2(16, 16);
	}

	public function update(delta: Float) {
		//position = position.add(cast(velocity.scalar(delta), Point));
	}
}