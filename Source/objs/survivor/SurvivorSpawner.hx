package objs.survivor;

import openfl.geom.Point;

class SurvivorSpawner {
	public var position: Point;
	
	public function new() {
		position = new Point(10.0, 10.0);
	}

	public function spawn() {
		var survivor = new Survivor(position.x, position.y);
		Layers.Add_Child(survivor.image, Layers.LayerType.HUMANOID);
		GameManager.survivors.push(survivor);
		trace("SPAWNED");
	}
}