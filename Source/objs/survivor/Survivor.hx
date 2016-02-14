package objs.survivor;

import openfl.display.Bitmap;

class Survivor extends Object {

	public function new(x_: Float, y_: Float) {
		super(x_, y_);

		image = new Bitmap(Data.image_map.get("survivor"));
	}

	public override function update(delta: Float) {
		super.update(delta);
	}
}