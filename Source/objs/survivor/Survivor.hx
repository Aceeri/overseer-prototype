package objs.survivor;

import openfl.display.Bitmap;

class Survivor extends Object {

	public function new(x_: Float, y_: Float) {
		super(x_, y_);

		image = new Bitmap(Data.image_map.get("survivor"));
		Layers.Add_Child(image, Layers.LayerType.HUMANOID);
		GameManager.survivors.push(this);
	}

	public override function update(delta: Float) {
		super.update(delta);
	}

	public function die() {
		Layers.Rem_Child(image, Layers.LayerType.HUMANOID);
		GameManager.survivors.remove(this);
	}
}